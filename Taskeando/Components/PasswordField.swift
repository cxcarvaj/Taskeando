//
//  PasswordField.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 24/5/25.
//
import SwiftUI

struct PasswordField: View {
    let title: String
    let placeholder: String
    
    @Binding var text: String
    @Binding var showPassword: Bool
    let isNewPassword: Bool
    var icon: String = "lock.fill"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                
                if showPassword {
                    TextField(placeholder, text: $text)
                        .textContentType(isNewPassword ? .newPassword : .password)
                } else {
                    SecureField(placeholder, text: $text)
                        .textContentType(isNewPassword ? .newPassword : .password)
                }
                
                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
        }
    }
}
