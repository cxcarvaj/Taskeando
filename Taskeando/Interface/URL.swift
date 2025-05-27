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
    static let loginUser = apiURL.appendingPathComponent("loginUser")
    static let loginUserJWT = apiURL.appendingPathComponent("loginUserJWT")
    static let validateUser = apiURL.appendingPathComponent("validateUser")
    static let project = apiURL.appendingPathComponent("project")
    static func getProject(id: UUID?) -> URL {
        project.appending(path: id?.uuidString ?? "")
    }
    static let projectJWT = apiURL.appendingPathComponent("projectJWT")
    static func getProjectJWT(id: UUID?) -> URL {
        projectJWT.appending(path: id?.uuidString ?? "")
    }
}

extension URLQueryItem {
    
}
