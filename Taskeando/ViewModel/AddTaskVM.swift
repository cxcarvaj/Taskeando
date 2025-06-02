//
//  AddTaskVM.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 31/5/25.
//


import Foundation

@Observable
final class AddTaskVM {
    var name: String = ""
    var summary: String = ""
    var dateInit: Date = .now
    var dateDeadline: Date = .now
    var priority: TaskPriority = .medium
    var state: TaskState = .none
    var daysRepeat: Int = 0
    var includeDeadline = false

    func getTask(projectID: UUID?) -> ProjectTaskDTO {
        let deadlineDate: Date? = includeDeadline ? dateDeadline : nil
        return ProjectTaskDTO(
            id: nil,
            name: name,
            summary: summary,
            dateInit: dateInit,
            dateDeadline: deadlineDate,
            priority: priority,
            state: state,
            daysRepeat: daysRepeat,
            projectId: projectID
        )
    }
}
