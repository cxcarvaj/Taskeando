//
//  PasswordStrengthIndicator.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 24/5/25.
//

import SwiftUI

struct PasswordStrengthIndicator: View {
    @Binding var passwordStrength: PasswordViewModel.PasswordStrength
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Seguridad de la contraseña: \(passwordStrength.description)")
                .font(.caption)
                .foregroundColor(passwordStrength.color)
            
            HStack(spacing: 4) {
                Rectangle()
                    .fill(passwordStrength == .weak || passwordStrength == .medium || passwordStrength == .strong ? passwordStrength.color : Color.gray.opacity(0.3))
                    .frame(height: 4)
                Rectangle()
                    .fill(passwordStrength == .medium || passwordStrength == .strong ? passwordStrength.color : Color.gray.opacity(0.3))
                    .frame(height: 4)
                Rectangle()
                    .fill(passwordStrength == .strong ? passwordStrength.color : Color.gray.opacity(0.3))
                    .frame(height: 4)
            }
            .clipShape(RoundedRectangle(cornerRadius: 2))
            
            Text("La contraseña debe contener al menos 8 caracteres, incluyendo mayúsculas, minúsculas, números y símbolos.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    PasswordStrengthIndicator(passwordStrength: .constant(.medium))
        .padding()
}
