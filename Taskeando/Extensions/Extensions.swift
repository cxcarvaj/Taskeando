//
//  Extensions.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 24/5/25.
//

import Foundation

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
