//
//  UsersLogic.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 24/5/25.
//


import Foundation

@Observable @MainActor
final class UsersLogic {
    let networkRepository: NetworkRepository
        
    init(networkRepository: NetworkRepository = Repository()) {
        self.networkRepository = networkRepository
    }
    
    func createUser(_ user: UserDTO) async throws {
        try await networkRepository.createUser( user)
    }
    
    func validateUser(token: String) async throws {
        try await networkRepository.validateUser(token: token)
    }
    
    func loginUser(user: String, pass: String) async throws {
        try await networkRepository.loginUser(user: user, pass: pass)
    }
    
    func loginUserJWT(user: String, pass: String) async throws {
        try await networkRepository.loginUserJWT(user: user, pass: pass)
    }
    
    func loginWithSIWA(tokenData: Data, siwaBody: SIWABody) async throws {
        try await networkRepository.loginWithSIWA(tokenData: tokenData, siwaBody: siwaBody)
    }
    
    func refreshJWT() async throws {
        try await networkRepository.refreshJWT()
    }
}
