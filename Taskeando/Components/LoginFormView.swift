//
//  LoginFormView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 24/5/25.
//

import SwiftUI

struct LoginForm: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @FocusState private var focusField: Field?
    
    @Binding var alertMessage: String
    @Binding var showAlert: Bool
    @Binding var showForgotPassword: Bool
    
    enum Field: Hashable {
        case email, password
    }
    
    var onLogin: () -> Void
    
    private var isLoginButtonEnabled: Bool {
        !email.isEmpty && !password.isEmpty && email.contains("@")
    }
    
    private func loginAction() {
        guard isLoginButtonEnabled else { return }
        
        isLoading = true
        
        Task {
            // Simulamos un delay para la autenticación
            try? await Task.sleep(for: .seconds(1.5))
            
            isLoading = false
            
            // Aquí iría tu lógica real de autenticación
            if email.lowercased() == "demo@example.com" && password == "password" {
                onLogin()
            } else {
                alertMessage = "Credenciales incorrectas. Por favor, inténtalo de nuevo."
                showAlert = true
            }
        }
    }


    var body: some View {
        VStack(spacing: 25) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Email")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundStyle(.secondary)
                    
                    TextField("usuario@ejemplo.com", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focusField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit {
                            focusField = .password
                        }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Contraseña")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.secondary)
                    
                    SecureField("********", text: $password)
                        .textContentType(.password)
                        .focused($focusField, equals: .password)
                        .submitLabel(.go)
                        .onSubmit {
                            loginAction()
                        }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                
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
                isLoading: isLoading,
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
    @Previewable @State var alertMessage: String = ""
    @Previewable @State var showAlert: Bool = false
    @Previewable @State var showForgotPassword: Bool = false
    LoginForm(alertMessage: $alertMessage,
              showAlert: $showAlert,
              showForgotPassword: $showForgotPassword,
              onLogin: {})
}
