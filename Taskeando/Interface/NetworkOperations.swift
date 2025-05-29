//
//  NetworkOperations.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 29/5/25.
//


import Foundation

struct NetworkOperations {
    let request: URLRequest
    let status: Int?
}

actor OperationsManager {
    static let shared = OperationsManager()
    
    let networkRepository = Repository()
    
    private init() {}
    
    private var operations: [NetworkOperations] = []
    
    func addOperation(_ operation: NetworkOperations) {
        operations.append(operation)
    }
    
    func sendPendingsOperations() async throws {
        for operation in operations {
            if let status = operation.status {
                try await networkRepository.getStatus(operation.request,
                                            status: status)
            } else {
                try await networkRepository.getStatus(operation.request)
            }
        }
    }
}
