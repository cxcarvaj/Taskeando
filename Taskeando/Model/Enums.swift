//
//  Enums.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 23/5/25.
//

import Foundation

enum UserType: String, Codable {
    case admin, user, none
}

enum TaskState: String, Codable {
    case active
    case cancelled
    case completed
    case inactive
    case onHold
    case pending
}

enum ProjectType: String, Codable {
    case design
    case development
    case education
    case event
    case finance
    case management
    case marketing
    case maintenance
    case documentation
    case research
    case support
    case testing
}
