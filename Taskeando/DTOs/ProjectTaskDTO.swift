//
//  ProjectTaskDTO.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 30/5/25.
//

import Foundation

struct ProjectTaskDTO: Codable {
    let id: UUID?
    let name: String
    let summary: String
    let dateInit: Date
    let dateDeadline: Date?
    let priority: TaskPriority
    let state: TaskState
    let daysRepeat: Int
    let projectId: UUID?
    
    var toTask: ProjectTask {
        ProjectTask(id: id, name: name, summary: summary, dateInit: dateInit, dateDeadline: dateDeadline, priority: priority, state: state, daysRepeat: daysRepeat)
    }
}
