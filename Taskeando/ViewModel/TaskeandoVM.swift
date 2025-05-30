//
//  TaskeandoVM.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 23/5/25.
//


import Foundation
import SMP25Kit
import AuthenticationServices


enum SIWAState {
    case authorized
    case notAuthorized
    case notRegister
}

@Observable @MainActor
final class TaskeandoVM {
    let projectsLogic: ProjectsLogic
    let usersLogic: UsersLogic
    
    var isUserLogged = true
    var isLoading = false
    var isLoadingProjects = false
    var showAlert = false
    var alertMessage = ""
    
    var siwaState: SIWAState = .notRegister
    
    var showSIWA: Bool {
        switch siwaState {
        case .authorized:
            return false
        case .notAuthorized:
            return true
        case .notRegister:
            return true
        }
    }
    
    init(networkRepository: NetworkRepository = Repository()) {
        self.projectsLogic = ProjectsLogic(networkRepository: networkRepository)
        self.usersLogic = UsersLogic(networkRepository: networkRepository)
        Task {
//            self.isUserLogged = SecKeyStore.shared.readValue(withLabel: GlobalIDs.tokenID.rawValue) != nil
//            self.isUserLogged = SecKeyStore.shared.readValue(withLabel: GlobalIDs.tokedJWT.rawValue) != nil
            if let _ = SecKeyStore.shared.readValue(withLabel: GlobalIDs.tokenJWT.rawValue) {
                try await usersLogic.refreshJWT()
            } else {
                isUserLogged = false
            }
            
            let provider = ASAuthorizationAppleIDProvider()
            if let appleIDUserData = SecKeyStore.shared.readValue(withLabel: GlobalIDs.appleSIWA.rawValue),
               let appleIDUser = String(data: appleIDUserData, encoding: .utf8) {
                let state = try await provider.credentialState(forUserID: appleIDUser)
                switch state {
                case .authorized:
                    siwaState = .authorized
                case .notFound:
                    siwaState = .notRegister
                case .revoked:
                    AuthCredentialManager().clearAllCredentials()
                default:
                    siwaState = .notAuthorized
                }
            }
        }
    }
    
    func createUser(_ user: UserDTO) async {
        do {
            isLoading.toggle()
            try await usersLogic.createUser(user)
            isLoading.toggle()
        } catch {
            isLoading.toggle()
            alertMessage = "Error al crear la cuenta: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func validateUser(token: String) async {
        do {
            try await usersLogic.validateUser(token: token)
        } catch {
            alertMessage = "Error al validar al usuario: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func loginUser(user: String, pass: String) async {
        do {
            try await usersLogic.loginUser(user: user, pass: pass)
            self.isUserLogged = SecKeyStore.shared.readValue(withLabel: GlobalIDs.tokenID.rawValue) != nil
            try await projectsLogic.getProjects()
        } catch {
            alertMessage = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    func loginUserJWT(user: String, pass: String) async {
        do {
            try await usersLogic.loginUserJWT(user: user, pass: pass)
            self.isUserLogged = SecKeyStore.shared.readValue(withLabel: GlobalIDs.tokenJWT.rawValue) != nil
            try await projectsLogic.getProjects()
        } catch {
            alertMessage = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    func loginWithSIWA(result: Result<ASAuthorization, any Error>) async {
        do {
            switch result {
            case .success(let authorization):
                try await handleAuthorization(authorization: authorization.credential)
            case .failure(let error):
                print("Error al obtener la acreditación de SIWA: \(error)")
            }
        } catch {
            print("Error al validar SIWA: \(error)")
        }
    }
    
    func handleAuthorization(authorization: ASAuthorizationCredential) async throws {
        guard let credential = authorization as? ASAuthorizationAppleIDCredential,
              let token = credential.identityToken else { return }
        let request = SIWABody(name: credential.fullName?.givenName, lastName: credential.fullName?.familyName)
        try await usersLogic.loginWithSIWA(tokenData: token, siwaBody: request)
        AuthCredentialManager().saveCredentials(for: .SIWAToken(token: nil), credentials: credential.user)
        try await projectsLogic.getProjects()
        isUserLogged = true
    }
    
    func logout() {
        Task { await AuthMiddlewareManager.shared.clearAllCredentials() }
        isUserLogged = false
    }
    
    func addProject(_ project: Project) async throws {
         do {
             try await projectsLogic.addProject(project)
         } catch {
             alertMessage = error.localizedDescription
             showAlert.toggle()
         }
    }
    
    func getProjects() async throws {
        isLoadingProjects = true
        try await projectsLogic.getProjects()
        isLoadingProjects = false
    }
}
