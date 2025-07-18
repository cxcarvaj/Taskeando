//
//  LoginView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 23/5/25.
//


import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(TaskeandoVM.self) var vm

    @State private var email = ""
    @State private var password = ""
    @State private var showForgotPassword = false
    @State private var showSignUp = false
    @State private var showAlert = false
    @State private var alertMessage = ""
        
    var body: some View {
        VStack {
            // Header con logo
            VStack(spacing: 10) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
                    .foregroundStyle(.blue)
                    .padding(.bottom, 5)
                
                Text("TASKeando")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .padding(.bottom)
                
                Text("Gestiona tus proyectos de forma eficiente")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical)
            
            // Formulario de Login
            LoginForm(email: $email,
                      password: $password,
                      alertMessage: $alertMessage,
                      showAlert: $showAlert,
                      showForgotPassword: $showForgotPassword) {
//                await vm.loginUser(user: email, pass: password)
                await vm.loginUserJWT(user: email, pass: password)
            }
            
            // Opciones alternativas
            HStack {
                Text("¿No tienes cuenta?")
                    .foregroundStyle(.secondary)
                
                Button("Regístrate") {
                    showSignUp = true
                }
                .fontWeight(.medium)
                .foregroundStyle(.blue)
            }
            .font(.subheadline)
            .padding(.top, 30)
            
            // Inicios de sesión alternativos
            VStack(spacing: 20) {
                Text("O continúa con")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 20) {
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.email, .fullName]
                    } onCompletion: { result in
                        Task { await vm.loginWithSIWA(result: result) }
                    }
                    .frame(width: 250, height: 50)
//                    socialLoginButton(image: "g.circle.fill", color: .red)
                }
            }
            .padding(.top, 25)
        }
        .padding(.horizontal)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding()
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
        .sheet(isPresented: $showForgotPassword) {
            // Vista de recuperación de contraseña
            VStack {
                Text("Recuperar contraseña")
                    .font(.title)
                    .bold()
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showSignUp) {
            // Vista de registro
            VStack {
                SignUpView(email: $email, password: $password)
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
        
    private func socialLoginButton(image: String, color: Color) -> some View {
        Button {
            // Acción de inicio de sesión social
        } label: {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
                .padding()
                .foregroundColor(.white)
                .background(color)
                .clipShape(Circle())
        }
    }
}

// Preview
#Preview {
    ZStack {
        Color.gray.opacity(0.2).ignoresSafeArea()
        LoginView()
            .environment(TaskeandoVM(networkRepository: RepositoryTest()))
    }
}
