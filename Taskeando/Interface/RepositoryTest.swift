//
//  RepositoryTest.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 23/5/25.
//



import Foundation
import SMP25Kit

struct RepositoryTest: NetworkRepository {
    func getProjects() async throws(NetworkError) -> [Project] {
        [.test]
    }
}
