//
//  Repository.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 22/5/25.
//


import Foundation
import SMP25Kit

struct Repository: NetworkRepository {
    public init() {
        Task {
            await URLRequest.setDefaultAuthMethod(.bearer(tokenType: nil))
        }
    }
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
}

protocol NetworkRepository: NetworkInteractor, Sendable {
    var apiKey: String { get }
    var key: Data { get }
    func createUser(user: UserDTO) async throws(NetworkError)
    func loginWithSIWA(tokenData: Data, siwaBody: SIWABody) async throws(NetworkError)
    func validateUser(token: String) async throws(NetworkError)
    func loginUser(user: String, pass: String) async throws(NetworkError)
    func loginUserJWT(user: String, pass: String) async throws
    func refreshJWT() async throws(NetworkError)
    func createProject(project: Project) async throws(NetworkError)
    func getProjects() async throws(NetworkError) -> [Project]
    func getProject(id: UUID?) async throws(NetworkError) -> Project
    
    func sendMetrics<T>(_ metrics: T) async where T: Codable
}

extension NetworkRepository {
    var apiKey: String {
        let OBF: [UInt8] = [0x36+0x3D,0x7A-0x2E,0x41+0x06,0x46+0x02,0x33+0x00,0x69-0x31,0x18+0x36,0xBC-0x54,0x45+0x00,0x1E+0x2C,0x06+0x2A,0x88-0x29,0x28+0x39,0x6E-0x00,0x2C+0x40,0x0E+0x3B,0x3E+0x19,0xC5-0x4E,0x51+0x17,0x70+0x03,0x5F+0x1B,0x3B-0x0A,0x43-0x16,0x11+0x3B,0x0D+0x54,0x7F-0x0D,0x23+0x20,0x51+0x1B,0x6E-0x29,0x3E+0x31,0x4D+0x1B,0x83-0x1A,0x80-0x3F,0x2F+0x19,0x92-0x41,0x4C+0x25,0x3E+0x23,0xCA-0x51,0x40+0x06,0x43-0x13,0x71-0x2B,0x0D+0x4C]
        return String(data: Data(OBF), encoding: .utf8) ?? ""
    }
    
    var key: Data {
        // De dónde sacamos la Key? es la key obfuscada (el hmac) que es mi secret que forma parte del JWT. Es el mismo hmac del API de vapor
        let key: [UInt8] = [0x3B+0x2F,0x89-0x1A,0x12+0x50,0xCB-0x58,0x74-0x21,0xBA-0x46,0x55+0x10,0x22+0x54,0xC6-0x61]
        return Data(key)
    }
    
    func createUser(user: UserDTO) async throws(NetworkError) {
        let request: URLRequest = await .post(url: .createUser,
                                              body: user,
                                              authMethod: .apiKey(key: apiKey,
                                                                  headerName: "X-API-Key"))
        try await getStatus(request, status: 201)
        SecKeyStore.shared.storeValue(Data(user.email.utf8), withLabel: "validateEmailUser")
    }
    
    func validateUser(token: String) async throws(NetworkError) {
        guard let userEmailData = SecKeyStore.shared.readValue(withLabel: "validateEmailUser"),
              let userEmail = String(data: userEmailData, encoding: .utf8) else {
            throw NetworkError.security("No se ha podido validar el email de usuario pendiente.")
        }
        var request: URLRequest = await .post(url: .validateUser, body: EmailValidation(email: userEmail, token: token))
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        try await getStatus(request, status: 202)
        NotificationCenter.default.post(name: .userValidated, object: nil)
        SecKeyStore.shared.deleteValue(withLabel: "validateEmail")
    }
    
    func loginUser(user: String, pass: String) async throws(NetworkError) {
        let request: URLRequest = await .get(
            .loginUser,
            authMethod: .basic(username: user, password: pass)
        )
        let response = try await getJSON(request, type: Token.self) //getJSON? Es un buen nombre?
        await AuthMiddlewareManager.shared.saveToken(response.token)
    }
    
    func loginUserJWT(user: String, pass: String) async throws(NetworkError) {
        let request: URLRequest = await .get(
            .loginUserJWT,
            authMethod: .basic(username: user, password: pass)
        )
        let response = try await getJSON(request, type: Token.self)
        let jwt = response.token


        let _ = try AuthCredentialManager().validateAndStoreJWT(
            jwt: jwt,
            issuer: "TaskeandoAPI",
            key: key
        )
    }
    
    func loginWithSIWA(tokenData: Data, siwaBody: SIWABody) async throws(NetworkError) {
        guard let tokenString = String(data: tokenData, encoding: .utf8) else {
            throw .security("Error en la conversión del token a string")
        }
        let request: URLRequest = await .post(url: .loginSIWA, body: siwaBody, authMethod: .SIWAToken(token: tokenString))
        
        let jwtToken = try await getJSON(request, type: Token.self).token
        let _ = try AuthCredentialManager().validateAndStoreJWT(
            jwt: jwtToken,
            issuer: "TaskeandoAPI",
            key: key
        )
    }
    
    func refreshJWT() async throws(NetworkError) {
        let jwtToken = try await getJSON(.get(.refreshJWT, authMethod: .bearer(tokenType: .tokenJWT)), type: Token.self).token
        let _ = try AuthCredentialManager().validateAndStoreJWT(
            jwt: jwtToken,
            issuer: "TaskeandoAPI",
            key: key
        )
    }
    
    func createProject(project: Project) async throws(NetworkError) {
//        try await getStatus(.post(url: .project, body: project), status: 202)
        try await getStatus(.post(url: .projectJWT, body: project, authMethod: .bearer(tokenType: .tokenJWT)), status: 202)
    }

    func getProjects() async throws(NetworkError) -> [Project] {
//        try await getJSON(.get(.project), type: [Project].self)
        try await getJSON(.get(.projectJWT, authMethod: .bearer(tokenType: .tokenJWT)), type: [Project].self)
    }
    
    func getProject(id: UUID?) async throws(NetworkError) -> Project {
//        try await getJSON(.get(.getProject(id: id)), type: Project.self)
        try await getJSON(.get(.getProjectJWT(id: id), authMethod: .bearer(tokenType: .tokenJWT)), type: Project.self)
    }
    
    func sendMetrics<T>(_ metrics: T) async where T: Codable {
        let request: URLRequest = await .post(url: .sendMetrics, body: metrics)
        do {
            try await getStatus(request, status: 201)
        } catch {
            let operation = NetworkOperations(request: request, status: 201)
            await OperationsManager.shared.addOperation(operation)
        }
    }
    
}
