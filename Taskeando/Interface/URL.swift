//
//  URL.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 22/5/25.
//

import Foundation

let host = URL(string: "http://localhost:8080")!
let apiURL = host.appendingPathComponent("api")

extension URL {
    static let createUser = apiURL.appendingPathComponent("createUser")
    static let loginSIWA = apiURL.appendingPathComponent("loginSIWA")
    static let loginUser = apiURL.appendingPathComponent("loginUser")
    static let loginUserJWT = apiURL.appendingPathComponent("loginUserJWT")
    static let validateUser = apiURL.appendingPathComponent("validateUser")
    static let project = apiURL.appendingPathComponent("project")
    static let refreshJWT = apiURL.appendingPathComponent("refreshJWT")
    static let sendToken = apiURL.appendingPathComponent("deviceAPNSToken")
    
    static func getProject(id: UUID?) -> URL {
        project.appending(path: id?.uuidString ?? "")
    }
    static let projectJWT = apiURL.appendingPathComponent("projectJWT")
    static func getProjectJWT(id: UUID?) -> URL {
        projectJWT.appending(path: id?.uuidString ?? "")
    }
    
    static let createTask = apiURL.appendingPathComponent("task")
    
    static func getProjectTasks(id: UUID?) -> URL {
        projectJWT.appending(path: id?.uuidString ?? "").appending(path: "tasks")
    }
    static func putDeleteTask(id: UUID?) -> URL {
        createTask.appending(path: id?.uuidString ?? "").appending(path: "tasks")
    }
    
    static let sendMetrics = apiURL.appendingPathComponent("sendMetrics")

}

extension URLQueryItem {
    
}
