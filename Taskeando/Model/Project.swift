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
    let users: [User]
    let tasks: [ProjectTask]
}

struct ProjectTask: Codable, Identifiable, Hashable {
    let id: UUID?
    let name: String
    let summary: String
    let dateInit: Date
    let dateDeadline: Date?
    let priority: TaskPriority
    let state: TaskState
    let daysRepeat: Int
    let user: [User]
}
