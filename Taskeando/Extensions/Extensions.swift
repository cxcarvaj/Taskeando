//
//  Extensions.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 24/5/25.
//

import Foundation
import SwiftUI

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension TaskeandoVM {
    // Validación del formulario de registro
    func isSignUpFormValid(fullName: String, email: String, password: String, confirmPassword: String) -> Bool {
        return !fullName.trimmed().isEmpty &&
        email.isValidEmail() &&
        password.count >= 8 &&
        password == confirmPassword
    }
}

extension Notification.Name {
    static let userValidated = Notification.Name("userValidated")
    static let viewTask = Notification.Name("viewTask")
}

extension ProjectType {
    var color: Color {
        switch self {
        case .development: return .blue
        case .design: return .pink
        case .marketing: return .orange
        case .education: return .yellow
        case .event: return .purple
        case .management: return .teal
        case .documentation: return .brown
        case .maintenance, .research, .support, .testing, .finance, .none: return .gray
        }
    }
    var icon: String {
        switch self {
        case .development: return "hammer.fill"
        case .design: return "paintpalette.fill"
        case .marketing: return "megaphone.fill"
        case .education: return "textbubble.bubble.fill"
        case .event: return "calendar.badge.fill"
        case .finance: return "dollarsign.circle.fill"
        case .management: return "pencil.and.ink.circle.fill"
        case .maintenance: return "wrench.circle.fill"
        case .documentation: return "book.circle.fill"
        case .research: return "magnifyingglass.circle.fill"
        case .support: return "envelope.fill"
        case .testing: return "testtube.fill"
        case .none: return "questionmark.circle.fill"
        }
    }
}

extension TaskPriority {
    var color: Color {
        switch self {
        case .high, .urgent: return .red
        case .medium: return .yellow
        case .low: return .green
        }
    }
    var icon: String {
        switch self {
        case .high, .urgent: return "exclamationmark.triangle.fill"
        case .medium: return "exclamationmark.circle.fill"
        case .low: return "arrow.down.right.circle.fill"
        }
    }
}
