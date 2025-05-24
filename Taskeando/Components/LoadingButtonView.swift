//
//  LoadingButtonView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 24/5/25.
//

import SwiftUI

struct LoadingButton: View {
    // MARK: - Propiedades requeridas
    let title: String
    let action: () -> Void
    
    // MARK: - Estados y propiedades opcionales con valores predeterminados
    var isLoading: Bool = false
    var isEnabled: Bool = true
    
    // MARK: - Opciones de personalización visual
    var icon: String? = nil
    var loadingTint: Color = .white
    var fontWeight: Font.Weight = .semibold
    var height: CGFloat = 50
    var cornerRadius: CGFloat = 15
    var horizontalPadding: CGFloat = 20
    var verticalPadding: CGFloat = 0
    var topPadding: CGFloat = 0
    
    // Colores
    var primaryGradient: [Color] = [.blue, .indigo]
    var disabledGradient: [Color] = [.gray.opacity(0.5), .gray.opacity(0.7)]
    var foregroundColor: Color = .white
    
    // MARK: - Body del Componente
    var body: some View {
        Button {
            if isEnabled && !isLoading {
                action()
            }
        } label: {
            HStack {
                if isLoading {
                    ProgressView()
                        .tint(loadingTint)
                        .padding(.trailing, 5)
                }
                
                if let icon = icon, !isLoading {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.trailing, 5)
                }
                
                Text(title)
                    .fontWeight(fontWeight)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(
                isEnabled && !isLoading
                    ? LinearGradient(colors: primaryGradient, startPoint: .leading, endPoint: .trailing)
                    : LinearGradient(colors: disabledGradient, startPoint: .leading, endPoint: .trailing)
            )
            .foregroundColor(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .disabled(!isEnabled || isLoading)
        .padding(.horizontal)
        .padding(.top, topPadding)
    }
}

// MARK: - Vista Previa
#Preview {
    VStack(spacing: 20) {
        // Botón normal
        LoadingButton(
            title: "Iniciar Sesión",
            action: { print("Botón presionado") }
        )
        
        // Botón cargando
        LoadingButton(
            title: "Procesando...",
            action: { },
            isLoading: true
        )
        
        // Botón deshabilitado
        LoadingButton(
            title: "No Disponible",
            action: { },
            isEnabled: false
        )
        
        // Botón personalizado
        LoadingButton(
            title: "Guardar Cambios",
            action: { print("Guardando...") },
            icon: "square.and.arrow.down",
            primaryGradient: [.green, .teal],
            foregroundColor: .white
        )
    }
    .padding()
}
