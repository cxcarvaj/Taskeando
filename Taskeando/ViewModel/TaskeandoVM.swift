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
    let usersLogic: UsersLogic
    
    var isUserLogged = true
    var isLoading = false
    var showAlert = false
    var alertMessage = ""
    
    init(networkRepository: NetworkRepository = Repository()) {
        self.projectsLogic = ProjectsLogic(networkRepository: networkRepository)
        self.usersLogic = UsersLogic(networkRepository: networkRepository)
        Task {
            try await Task.sleep(for: .seconds(0.5))
            self.isUserLogged = SecKeyStore.shared.readValue(withLabel: GlobalIDs.tokenID.rawValue) != nil
        }
    }
    
    func createUser(_ user: User) async {
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
}
