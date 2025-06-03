//
//  AddTaskVM.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 31/5/25.
//


import Foundation
import UserNotifications

@Observable @MainActor
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
        let taskID = UUID()
        Task {
            do {
                try await createNotification(deadline: deadlineDate, projectID: projectID, taskID: taskID)
            } catch {
                print("Error en la programación de la tarea.")
            }
        }
        
        return ProjectTaskDTO(
            id: taskID,
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
    
    func createNotification(deadline: Date?, projectID: UUID?, taskID: UUID) async throws {
        guard let deadline, let projectID,
              let url = Bundle.main.url(forResource: "SwiftySticker", withExtension: "png") else { return }
        
        let notification = UNMutableNotificationContent()
        notification.title = name
        notification.subtitle = summary
        //notification.sound = .default
        notification.sound = UNNotificationSound(named: UNNotificationSoundName("notification1.caf"))
        notification.attachments = [
            try UNNotificationAttachment(identifier: "logo", url: url)
        ]
        notification.userInfo = ["projectID": projectID.uuidString, "taskID": taskID.uuidString]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: deadline.timeIntervalSinceNow,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: notification,
                                            trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
    }
}
