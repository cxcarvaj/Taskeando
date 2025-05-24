//
//  TaskeandoVM.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 23/5/25.
//


import Foundation
import SMP25Kit

@Observable @MainActor
final class TaskeandoVM {
    let projectsLogic: ProjectsLogic
    
    var isUserLogged = true
    
    init(networkRepository: NetworkRepository = Repository()) {
        self.projectsLogic = ProjectsLogic(networkRepository: networkRepository)
        Task {
            try await Task.sleep(for: .seconds(0.5))
            self.isUserLogged = SecKeyStore.shared.readValue(withLabel: GlobalIDs.tokenID.rawValue) != nil
        }
    }
}
