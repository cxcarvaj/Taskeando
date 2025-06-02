//
//  AddTaskView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 31/5/25.
//


import SwiftUI

struct AddTaskView: View {
    @Environment(TaskeandoVM.self) private var vm
    @State private var taskVM = AddTaskVM()
    @Environment(\.dismiss) private var dismiss

    let project: Project

    // Accessibility - Focus field for screen readers
    @FocusState private var focusedField: Field?
    enum Field: Hashable {
        case name, summary
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nombre de la tarea", text: $taskVM.name)
                        .accessibilityLabel("Nombre de la tarea")
                        .accessibilityHint("Introduce el nombre de la tarea")
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .summary
                        }
                        .autocapitalization(.sentences)
                        .textContentType(.name)
                        .disableAutocorrection(false)

                    TextField("Descripción breve", text: $taskVM.summary)
                        .accessibilityLabel("Descripción de la tarea")
                        .accessibilityHint("Introduce una breve descripción para la tarea")
                        .focused($focusedField, equals: .summary)
                        .submitLabel(.done)
                        .autocapitalization(.sentences)
                        .disableAutocorrection(false)
                } header: {
                    Label("Información básica", systemImage: "info.circle")
                }

                Section {
                    DatePicker("Fecha de inicio", selection: $taskVM.dateInit, displayedComponents: [.date, .hourAndMinute])
                        .accessibilityLabel("Fecha de inicio")
                    Toggle(isOn: $taskVM.includeDeadline) {
                        Label("¿Tiene fecha límite?", systemImage: "calendar.badge.clock")
                    }
                    .toggleStyle(.switch)

                    if taskVM.includeDeadline {
                        DatePicker(
                            "Fecha límite",
                            selection: $taskVM.dateDeadline,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .accessibilityLabel("Fecha límite")
                    }
                } header: {
                    Label("Fechas", systemImage: "calendar")
                }

                Section {
                    Picker("Prioridad", selection: $taskVM.priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { p in
                            Label(p.localizedDisplay, systemImage: p.icon)
                                .tag(p)
                        }
                    }
                    .pickerStyle(.menu)
                    .accessibilityLabel("Prioridad de la tarea")

                    Picker("Estado", selection: $taskVM.state) {
                        ForEach(TaskState.allCases, id: \.self) { s in
                            Label(s.localizedDisplay, systemImage: s.icon)
                                .tag(s)
                        }
                    }
                    .pickerStyle(.menu)
                    .accessibilityLabel("Estado de la tarea")

                    Stepper(value: $taskVM.daysRepeat, in: 0...30) {
                        if taskVM.daysRepeat == 0 {
                            Text("No se repite")
                        } else if taskVM.daysRepeat == 1 {
                            Text("Repetir cada día")
                        } else {
                            Text("Repetir cada \(taskVM.daysRepeat) días")
                        }
                    }
                    .accessibilityLabel("Repetición")
                    .accessibilityValue(taskVM.daysRepeat == 0 ? "No se repite" : "Cada \(taskVM.daysRepeat) días")
                } header: {
                    Label("Detalles", systemImage: "list.bullet.rectangle.portrait")
                }
            }
            .navigationTitle("Nueva tarea")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .accessibilityLabel("Cancelar")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            await vm.addProject(task: taskVM.getTask(projectID: project.id))
                            dismiss()
                        }
                    } label: {
                        Label("Guardar", systemImage: "plus")
                    }
                    .accessibilityLabel("Guardar tarea")
                    .disabled(taskVM.name.isEmpty)
                }
            }
            .onAppear {
                focusedField = .name
            }
        }
    }
}

// MARK: - Helpers para accesibilidad y visual

extension TaskPriority {
    var localizedDisplay: String {
        switch self {
        case .urgent: return "Urgente"
        case .high: return "Alta"
        case .medium: return "Media"
        case .low: return "Baja"
        }
    }
}

extension TaskState {
    var localizedDisplay: String {
        switch self {
        case .pending: return "Pendiente"
        case .active: return "Activa"
        case .completed: return "Completada"
        case .cancelled: return "Cancelada"
        case .inactive: return "Inactiva"
        case .onHold: return "En espera"
        case .none: return "N/A"
        }
    }
    var icon: String {
        switch self {
        case .pending: return "clock"
        case .completed: return "checkmark.seal.fill"
        case .active: return "checkmark.seal.fill"
        case .cancelled: return "xmark.circle.fill"
        case .inactive: return "xmark.bin.fill"
        case .onHold: return "exclamationmark.triangle.fill"
        case .none:
            return "flashlight.off.circle.fill"
        }
    }
}

#Preview {
    AddTaskView(project: .test)
        .environment(TaskeandoVM(networkRepository: RepositoryTest()))
}
