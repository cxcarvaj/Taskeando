//
//  SignUpView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 24/5/25.
//

import SwiftUI
import AuthenticationServices

struct SignUpView: View {
    // MARK: - Properties
    @Environment(TaskeandoVM.self) var vm
    @Environment(\.dismiss) private var dismiss
    
    @State private var passwordVM = PasswordViewModel()
    @State private var fullName = ""
    @State private var confirmPassword = ""
    @State private var passwordStrength: PasswordStrength = .weak
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    @Binding var email: String
    @Binding var password: String
    
    @FocusState private var focusField: Field?
    @State private var showAppleError: Bool = false
    @State private var appleErrorMessage: String = ""
    
    enum Field: Hashable {
        case fullName, email, password, confirmPassword
    }
    // MARK: - Body
    var body: some View {
        @Bindable var vm = vm
        ScrollView {
            VStack(spacing: 30) {
                // Header
                headerView
                
                // Apple Sign In destacado
                VStack(spacing: 12) {
                    SignInWithAppleButton(.signUp) { request in
                        request.requestedScopes = [.email, .fullName]
                    } onCompletion: { result in
                        Task {
                            await vm.loginWithSIWA(result: result)
                        }
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 52)
                    .cornerRadius(12)
                    .padding(.horizontal, 8)
                    .accessibilityIdentifier("SignInWithAppleButton")
                    
                    Text("Regístrate con Apple para mayor rapidez y seguridad.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 6)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(.separator), lineWidth: 0.5)
                        .background(Color(.systemBackground).opacity(0.7))
                )
                .padding(.horizontal)
                .padding(.top, 4)
                
                HStack {
                    Divider().frame(height: 1)
                    Text("o crea una cuenta manualmente")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Divider().frame(height: 1)
                }
                .padding(.horizontal)
                .padding(.vertical, 2)
                
                // Formulario manual
                VStack(spacing: 20) {
                    FormTextField(
                        title: "Nombre completo",
                        placeholder: "Tu nombre y apellidos",
                        icon: "person.fill",
                        text: $fullName,
                        contentType: .name,
                        keyboardType: .default,
                        capitalization: .words
                    )
                    .focused($focusField, equals: .fullName)
                    
                    FormTextField(
                        title: "Correo electrónico",
                        placeholder: "ejemplo@correo.com",
                        icon: "envelope.fill",
                        text: $email,
                        contentType: .username,
                        keyboardType: .emailAddress,
                        capitalization: .never
                    )
                    .focused($focusField, equals: .email)
                    
                    PasswordField(
                        title: "Contraseña",
                        placeholder: "Mínimo 8 caracteres",
                        text: $password,
                        showPassword: $showPassword,
                        isNewPassword: true
                    )
                    .focused($focusField, equals: .password)
                    
                    PasswordField(
                        title: "Confirmar contraseña",
                        placeholder: "Vuelve a escribir tu contraseña",
                        text: $confirmPassword,
                        showPassword: $showConfirmPassword,
                        isNewPassword: true,
                        icon: "lock.shield.fill"
                    )
                    .focused($focusField, equals: .confirmPassword)
                    
                    PasswordStrengthIndicator(passwordStrength: $passwordVM.passwordStrength)
                        .animation(.easeInOut, value: password)
                }
                .padding(.horizontal)
                .padding(.top, 4)
                
                // Botón de registro manual
                LoadingButton(
                    title: "Crear Cuenta",
                    action: signUpAction,
                    isLoading: vm.isLoading,
                    isEnabled: isSignUpButtonEnabled,
                    icon: "person.badge.plus",
                    cornerRadius: 15,
                    primaryGradient: [.blue, .indigo]
                )
                .padding(.horizontal)
                .padding(.top, 2)
                
                // Errores de Apple
                if showAppleError {
                    Text(appleErrorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .transition(.opacity)
                }
                
                // Política de privacidad
                privacyText
                
                // Volver al login
                backToLoginButton
            }
            .padding(.top)
            .padding(.bottom, 30)
        }
        .alert("Aviso", isPresented: $vm.showAlert) {
            Button("OK") {}
        } message: {
            Text(vm.alertMessage)
        }
        .onAppear {
            passwordVM.updatePasswordStrength(for: password)
        }
        .onChange(of: password) {
            passwordVM.updatePasswordStrength(for: password)
        }
        .onSubmit {
            switch focusField {
            case .fullName:
                focusField = .email
            case .email:
                focusField = .password
            case .password:
                focusField = .confirmPassword
            case .confirmPassword:
                if isSignUpButtonEnabled {
                    signUpAction()
                }
            case .none:
                break
            }
        }
    }
    
    // MARK: - Views Components
    private var headerView: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.badge.plus.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundStyle(.blue)
                .padding(.bottom, 5)
            
            Text("Crear Cuenta")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .padding(.bottom, 5)
            
            Text("Únete a TASKeando y gestiona tus proyectos")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical)
    }
        
    private var privacyText: some View {
        VStack {
            Text("Al crear una cuenta, aceptas nuestros [Términos de Servicio](https://taskeando.ejemplo.com/terminos) y [Política de Privacidad](https://taskeando.ejemplo.com/privacidad).")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.vertical, 10)
    }
    
    private var backToLoginButton: some View {
        Button {
            dismiss()
        } label: {
            Text("¿Ya tienes cuenta? Iniciar sesión")
                .foregroundStyle(.blue)
                .font(.subheadline)
        }
        .padding(.vertical, 15)
    }
    
    // MARK: - Computed Properties
    
    private var isSignUpButtonEnabled: Bool {
        vm.isSignUpFormValid(
             fullName: fullName,
             email: email,
             password: password,
             confirmPassword: confirmPassword
         )
    }
    
    // MARK: - Functions
    
    private func signUpAction() {
        hideKeyboard()
        Task {
            await vm.createUser(
                UserDTO(email: email,
                     password: password,
                     name: fullName,
                     avatar: nil,
                     role: .none))
            dismiss()
        }
    }
    
    // Método moderno para ocultar el teclado en SwiftUI
    private func hideKeyboard() {
        focusField = nil
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var email: String = ""
    @Previewable @State var password: String = ""
    SignUpView(email: $email, password: $password)
        .environment(TaskeandoVM(networkRepository: RepositoryTest()))
}
