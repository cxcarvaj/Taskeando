//
//  LoginFormView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 24/5/25.
//

import SwiftUI

struct LoginForm: View {
    @Environment(TaskeandoVM.self) var vm
    
    @State private var showPassword = false
    
    @FocusState private var focusField: Field?
    
    @Binding var email: String
    @Binding var password: String
    @Binding var alertMessage: String
    @Binding var showAlert: Bool
    @Binding var showForgotPassword: Bool
    
    enum Field: Hashable {
        case email, password
    }
    
    var onLogin: () async -> Void
    
    private var isLoginButtonEnabled: Bool {
        !email.isEmpty && !password.isEmpty && email.contains("@")
    }
    
    private func loginAction() {
        guard isLoginButtonEnabled else { return }
        
        vm.isLoading = true
        
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            vm.isLoading = false
            
            // Aquí iría lógica real de autenticación
            if !email.lowercased().isEmpty && !password.isEmpty {
                await onLogin()
                email = ""
                password = ""
                focusField = .email
            } else {
                alertMessage = "Credenciales incorrectas. Por favor, inténtalo de nuevo."
                showAlert = true
            }
        }
    }


    var body: some View {
        VStack(spacing: 25) {
            FormTextField(
                title: "Email",
                placeholder: "usuario@ejemplo.com",
                icon: "envelope.fill",
                text: $email,
                contentType: .emailAddress,
                keyboardType: .emailAddress,
                capitalization: .never
            )
            .focused($focusField, equals: .email)
            
            VStack(alignment: .leading, spacing: 8) {
                PasswordField(
                    title: "Contraseña",
                    placeholder: "********",
                    text: $password,
                    showPassword: $showPassword,
                    isNewPassword: false
                )
                .focused($focusField, equals: .password)
                
                Button("¿Olvidaste tu contraseña?") {
                    showForgotPassword = true
                }
                .font(.footnote)
                .padding(.top, 5)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            LoadingButton(
                title: "Iniciar Sesión",
                action: loginAction,
                isLoading: vm.isLoading,
                isEnabled: isLoginButtonEnabled,
                fontWeight: .semibold,
                cornerRadius: 15,
                primaryGradient: [.blue, .indigo]
            )
        }
        .padding(.horizontal)
    }
}
#Preview {
    @Previewable @State var email: String = ""
    @Previewable @State var password: String = ""
    @Previewable @State var alertMessage: String = ""
    @Previewable @State var showAlert: Bool = false
    @Previewable @State var showForgotPassword: Bool = false
    LoginForm(email:$email,
              password: $password,
              alertMessage: $alertMessage,
              showAlert: $showAlert,
              showForgotPassword: $showForgotPassword,
              onLogin: {}
    )
}
