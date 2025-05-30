//
//  AddProjectView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 29/5/25.
//


import SwiftUI

struct AddProjectView: View {
    @Environment(TaskeandoVM.self) var vm
    @State private var projectVM = AddProjectVM()
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?
    @State private var isLoading = false
    @State private var showValidation = false

    enum Field: Hashable {
        case name, summary
    }
    
    // Validación simple
    private var isFormValid: Bool {
        !projectVM.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !projectVM.summary.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section(header: Text("Información del proyecto").fontWeight(.semibold)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nombre del proyecto")
                                .font(.headline)
                                .accessibilityLabel("Nombre del proyecto")
                            TextField("Escribe el nombre", text: $projectVM.name)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled()
                                .focused($focusedField, equals: .name)
                                .submitLabel(.next)
                                .accessibilityHint("Campo obligatorio")
                            if showValidation && projectVM.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                Text("El nombre es obligatorio")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .accessibilityLabel("El nombre es obligatorio")
                            }
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Resumen")
                                .font(.headline)
                                .accessibilityLabel("Resumen del proyecto")
                            TextField("Describe brevemente el proyecto", text: $projectVM.summary)
                                .textInputAutocapitalization(.sentences)
                                .focused($focusedField, equals: .summary)
                                .submitLabel(.done)
                                .accessibilityHint("Campo obligatorio")
                            if showValidation && projectVM.summary.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                Text("El resumen es obligatorio")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .accessibilityLabel("El resumen es obligatorio")
                            }
                        }
                    }
                    
                    Section(header: Text("Detalles del proyecto").fontWeight(.semibold)) {
                        ProjectPicker(projectType: $projectVM.type)
                        
                        StatePicker(taskState: $projectVM.state)
                    }
                }
                // Loading overlay
                if isLoading {
                    Color.black.opacity(0.18).ignoresSafeArea()
                    ProgressView("Creando proyecto...")
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                        .accessibilityLabel("Creando proyecto")
                }
            }
            .navigationTitle("Nuevo Proyecto")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .accessibilityIdentifier("CancelarAddProject")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        showValidation = true
                        guard isFormValid else { return }
                        hideKeyboard()
                        Task {
                            isLoading = true
                            try await vm.addProject(projectVM.getProject())
                            try await vm.getProjects()
                            isLoading = false
                            dismiss()
                        }
                    }) {
                        Label("Guardar", systemImage: "plus")
                            .font(.headline)
                    }
                    .disabled(!isFormValid || isLoading)
                    .accessibilityIdentifier("GuardarAddProject")
                }
            }
            .interactiveDismissDisabled(isLoading) // Bloquea swipe si está cargando
            .onSubmit {
                if focusedField == .name {
                    focusedField = .summary
                } else if focusedField == .summary, isFormValid {
                    hideKeyboard()
                }
            }
            .onAppear {
                Task {
                    try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 segundos
                    focusedField = .name
                }
            }
        }
    }
    
    private func hideKeyboard() {
        focusedField = nil
    }
}

#Preview {
    AddProjectView()
        .environment(TaskeandoVM(networkRepository: RepositoryTest()))
}
