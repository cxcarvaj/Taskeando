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
        Task { try await self.getProjects() }
    }
    
    func getProjects() async throws {
        do {
            self.projects = try await networkRepository.getProjects()
        } catch {}
    }
    
    func addProject(_ project: Project) async throws {
        do {
            try await networkRepository.createProject(project)
        } catch {}
    }
    
    func addProject(task: ProjectTaskDTO) async throws {
        do {
            try await networkRepository.createTask(task)
            try await getProjects()
        } catch {
            print(error)
        }
    }
    
    func getProjectFromTask(task: ProjectTask) -> Project? {
        projects.first { $0.tasks.contains(where: { $0.id == task.id }) }
    }
    
    func getProjectTask(notification: Notification) -> (project: Project, task: ProjectTask)? {
        guard let userinfo = notification.userInfo as? [String: UUID],
              let projectID = userinfo["projectID"],
              let taskID = userinfo["taskID"],
              let project = projects.first(where: { $0.id == projectID }),
              let task = project.tasks.first(where: { $0.id == taskID })
        else { return nil }
        return (project, task)
    }
}
