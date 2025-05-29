import SwiftUI

struct WithoutNetworkView: View {
    @State private var isAnimating = false
    @State private var isRetrying = false

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.08))
                    .frame(width: 100, height: 100)
                Image(systemName: "wifi.slash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 58, height: 58)
                    .foregroundStyle(.secondary)
                    .rotationEffect(.degrees(isAnimating ? 10 : -10))
                    .animation(
                        .easeInOut(duration: 0.7).repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
            .padding(.top, 20)

            Text("Sin conexión a Internet")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            Text("No se ha detectado una conexión a internet. TASKeando requiere acceso a la red para funcionar correctamente.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)

            if isRetrying {
                ProgressView("Reintentando...")
                    .padding(.top, 12)
            } else {
                Button {
                    Task {
                        isRetrying = true
                        // Simula intento de reconexión breve (reemplaza con tu lógica real)
                        try? await Task.sleep(for: .seconds(1.5))
                        isRetrying = false
                    }
                } label: {
                    Label("Intentar de nuevo", systemImage: "arrow.clockwise")
                        .font(.headline)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 13)
                        .background(Color.accentColor.opacity(0.12))
                        .foregroundStyle(Color.accentColor)
                        .clipShape(Capsule())
                }
                .accessibilityIdentifier("RetryNetworkButton")
                .padding(.top, 6)
            }
        }
        .padding()
        .frame(maxWidth: 350)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.thinMaterial)
                .shadow(color: .black.opacity(0.16), radius: 10, x: 0, y: 8)
        )
        .padding(.horizontal, 26)
        .onAppear { isAnimating = true }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    WithoutNetworkView()
}
