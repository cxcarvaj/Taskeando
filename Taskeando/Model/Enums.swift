//
//  Enums.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 23/5/25.
//

import SwiftUI

enum UserType: String, Codable {
    case admin, user, none
}

enum TaskState: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case active
    case cancelled
    case completed
    case inactive
    case onHold
    case pending
    case none
}

enum ProjectType: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
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
    case none
}

enum PasswordStrength: String {
    case weak, medium, strong
    
    var color: Color {
        switch self {
            case .weak: return .red
            case .medium: return .yellow
            case .strong: return .green
        }
    }
    
    var description: String {
        switch self {
            case .weak: return "Débil"
            case .medium: return "Media"
            case .strong: return "Fuerte"
        }
    }
}


struct EmailValidation: Codable {
    let email: String
    let token: String
}

struct SIWABody: Codable {
    let name: String?
    let lastName: String?
}

enum TaskPriority: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case urgent
    case high
    case medium
    case low
}
