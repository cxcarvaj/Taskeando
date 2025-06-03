//
//  TaskDetailView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 2/6/25.
//

import SwiftUI

struct TaskDetailView: View {
    let task: ProjectTask
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: dynamicTypeSize > .large ? 24 : 16) {
                // Sección de estado - Destacado en la parte superior
                StateChip(state: task.state)
                    .padding(.bottom, 8)
                
                // Título de la tarea
                Text(task.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityAddTraits(.isHeader)
                
                Divider()
                    .padding(.vertical, 8)
                
                // Descripción
                descriptionView
                
                // Fecha de vencimiento
                if let dueDate = task.dateDeadline {
                    deadlineView(dueDate)
                }
                
                // Separador visual antes de acciones
                Divider()
                    .padding(.vertical, 12)
                
                // Sección de acciones
                actionButtons
                
                Spacer(minLength: 40)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("Detalles")
        .navigationBarTitleDisplayMode(.inline)
        .background(colorScheme == .dark ? Color.black.opacity(0.8) : Color.gray.opacity(0.05))
        .toolbarRole(.editor) // Mejora la experiencia de navegación
    }
    
    // MARK: - Componentes de UI

    private var descriptionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Descripción", iconName: "doc.text")
            
            if task.summary.isEmpty {
                Text("Sin descripción")
                    .italic()
                    .foregroundColor(.secondary)
            } else {
                Text(task.summary)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(12)
                    .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    .accessibilityLabel("Descripción: \(task.summary)")
            }
        }
    }
    
    private func deadlineView(_ dueDate: Date) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Fecha límite", iconName: "calendar.badge.clock")
            
            HStack(spacing: 12) {
                DateBadge(date: dueDate)
                
                VStack(alignment: .leading) {
                    Text(isOverdue(dueDate) ? "Vencida" : "Pendiente")
                        .fontWeight(.medium)
                        .foregroundColor(isOverdue(dueDate) ? .red : .primary)
                    
                    Text(timeRemaining(for: dueDate))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .accessibilityElement(children: .combine)
            }
            .padding(12)
            .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 16) {
            Button {
                // Acción para editar
            } label: {
                Label("Editar tarea", systemImage: "pencil")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            
            Button {
                // Acción para marcar como completada
            } label: {
                Label(task.state == .completed ? "Reabrir tarea" : "Completar tarea",
                      systemImage: task.state == .completed ? "arrow.uturn.backward" : "checkmark")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(task.state == .completed ? .orange : .green)
        }
        .fontWeight(.medium)
    }
    
    // MARK: - Funciones de utilidad
    
    private func statusColor(for status: TaskState) -> Color {
        switch status {
        case .pending, .inactive, .onHold, .none:
            return .gray
        case .active:
            return .blue
        case .completed:
            return .green
        case .cancelled:
            return .orange
        }
    }
    
    private func isOverdue(_ date: Date) -> Bool {
        return date < .now
    }
    
    private func timeRemaining(for date: Date) -> String {
        if date < .now {
            let components = Calendar.current.dateComponents([.day], from: date, to: .now)
            if let days = components.day, days > 0 {
                return "Vencida hace \(days) día\(days == 1 ? "" : "s")"
            }
            return "Vencida hoy"
        } else {
            let components = Calendar.current.dateComponents([.day], from: .now, to: date)
            if let days = components.day {
                if days == 0 {
                    return "Vence hoy"
                } else if days == 1 {
                    return "Vence mañana"
                } else {
                    return "Vence en \(days) días"
                }
            }
            return "Fecha próxima"
        }
    }
}

// MARK: - Componentes reutilizables

struct SectionHeader: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: iconName)
                .foregroundColor(.accentColor)
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isHeader)
    }
}


#Preview {
    NavigationStack {
        TaskDetailView(task: .test)
    }
}
