//
//  PasswordViewModel.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 24/5/25.
//

import SwiftUI

@Observable
final class PasswordViewModel {
    var passwordStrength: PasswordStrength = .weak
    
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
    
    func updatePasswordStrength(for password: String) {
        // Criterios de seguridad
        let lengthCriteria = password.count >= 8
        let uppercaseCriteria = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let lowercaseCriteria = password.rangeOfCharacter(from: .lowercaseLetters) != nil
        let digitCriteria = password.rangeOfCharacter(from: .decimalDigits) != nil
        let specialCharCriteria = password.rangeOfCharacter(from: .punctuationCharacters) != nil
        
        // Evaluación
        let criteriaMet = [lengthCriteria, uppercaseCriteria, lowercaseCriteria, digitCriteria, specialCharCriteria].filter { $0 }.count
        
        switch criteriaMet {
        case 0...2:
            passwordStrength = .weak
        case 3...4:
            passwordStrength = .medium
        case 5:
            passwordStrength = .strong
        default:
            passwordStrength = .weak
        }
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    func doPasswordsMatch(_ password: String, _ confirmPassword: String) -> Bool {
        return password == confirmPassword
    }
}
