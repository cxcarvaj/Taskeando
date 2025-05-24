//
//  Project.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 23/5/25.
//


import Foundation

struct Project: Codable, Identifiable, Hashable {
    let id: UUID?
    let name: String
    let summary: String?
    let type: ProjectType
    let state: TaskState
}

extension Project {
    static let test = Project(id: UUID(), name: "Be Native", summary: "Proyecto de la app de Be Native", type: .development, state: .active)
}