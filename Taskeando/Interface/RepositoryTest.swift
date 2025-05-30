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

extension Project {
    static let test = Project(id: UUID(), name: "Be Native", summary: "Proyecto de la app de Be Native", type: .development, state: .active, users: [.test], tasks: [.test])
}

extension User {
    static let test = User(email: "cxcarvaj@gmail.com", name: "Carlos Carvajal", avatar: nil)
}

extension ProjectTask {
    static let test = ProjectTask(id: UUID(),
                                  name: "Challenge de Passkey en base de datos",
                                  summary: "Hay que cambiar el tipo de dato de la base de datos a String para que busque por base64 y no por el tipo Data en bruto",
                                  dateInit: .now,
                                  dateDeadline: .now.addingTimeInterval(48 * 60 * 60),
                                  priority: .medium,
                                  state: .active,
                                  daysRepeat: 0,
                                  user: [.test])
}
