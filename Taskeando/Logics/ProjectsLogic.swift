//
//  ProjectsLogic.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 23/5/25.
//

import Foundation

@Observable @MainActor
final class ProjectsLogic {
    let networkRepository: NetworkRepository
    
    var projects: [Project] = []
    
    init(networkRepository: NetworkRepository = Repository()) {
        self.networkRepository = networkRepository
        Task { await self.getProjects() }
    }
    
    func getProjects() async {
        do {
            self.projects = try await networkRepository.getProjects()
        } catch {}
    }
}
