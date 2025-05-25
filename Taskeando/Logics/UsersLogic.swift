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
    
    func createUser(_ user: User) async throws {
        try await networkRepository.createUser(user: user)
    }
}
