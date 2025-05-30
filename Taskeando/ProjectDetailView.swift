//
//  ProjectDetailView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 29/5/25.
//

import SwiftUI

struct ProjectDetailView: View {
    @State private var detailVM = ProjectDetailVM()
    @State private var addTask = false
    
    let project: Project
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ProjectHeaderView(project: project, detailVM: $detailVM)
                
                TaskSectionView(
                    tasks: project.tasks,
                    onAdd: { addTask = true }
                )
            }
            .padding(.horizontal)
            .padding(.top, 4)
        }
        .navigationTitle(project.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .sheet(isPresented: $addTask) {
            // Tu vista para agregar tareas aquí, por ejemplo:
            // AddTaskView(project: project, onDismiss: { addTask = false })
            Text("Vista para añadir tarea")
                .presentationDetents([.medium, .large])
        }
    }
}

// MARK: - Header

struct ProjectHeaderView: View {
    let project: Project
    @Binding var detailVM: ProjectDetailVM

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                ProjectIconView(type: project.type)
                VStack(alignment: .leading, spacing: 5) {
                    Text(project.name)
                        .font(.title2.bold())
                        .foregroundStyle(.primary)
                    if let summary = project.summary {
                        Text(summary)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
            }
            Divider()
            VStack(alignment: .leading, spacing: 30) {
                ProjectPropertyView(
                    icon: "cube.fill",
                    label: "Tipo",
                    content: ProjectPicker(projectType: $detailVM.type)
                )
                ProjectPropertyView(
                    icon: "flag.fill",
                    label: "Estado",
                    content: StatePicker(taskState: $detailVM.state)
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.thinMaterial)
                .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 4)
        )
        .accessibilityElement(children: .combine)
    }
}

struct ProjectIconView: View {
    let type: ProjectType
    var body: some View {
        ZStack {
            Circle()
                .fill(type.color.opacity(0.13))
                .frame(width: 56, height: 56)
            Image(systemName: type.icon)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(type.color)
        }
        .accessibilityHidden(true)
    }
}

struct ProjectPropertyView<Content: View>: View {
    let icon: String
    let label: String
    let content: Content

    init(icon: String, label: String, content: Content) {
        self.icon = icon
        self.label = label
        self.content = content
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(Color.accentColor)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            content
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Tasks Section

struct TaskSectionView: View {
    let tasks: [ProjectTask]
    var onAdd: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Tareas")
                    .font(.title3.bold())
                    .foregroundStyle(.primary)
                Spacer()
                Button {
                    onAdd()
                } label: {
                    Label("Agregar tarea", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .font(.title3)
                        .padding(10)
                        .contentShape(Circle())
                }
                .buttonStyle(.bordered)
                .accessibilityIdentifier("AddTaskButton")
            }
            if tasks.isEmpty {
                ContentUnavailableView("No hay tareas",
                                       systemImage: "tray",
                                       description: Text("Aún no se han agregado tareas a este proyecto."))
                    .padding(.vertical, 32)
            } else {
                VStack(spacing: 16) {
                    ForEach(tasks) { task in
                        TaskGroupBoxView(task: task)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.background)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
        )
    }
}

// MARK: - Task Card

struct TaskGroupBoxView: View {
    let task: ProjectTask
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 6) {
                if !task.summary.isEmpty {
                    Text(task.summary)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                HStack(alignment: .top) {
                    Text("Inicio: \(task.dateInit.formatted(date: .numeric, time: .omitted))")
                    Spacer()
                    VStack(alignment: .leading) {
                        if let deadline = task.dateDeadline {
                            Text("Límite: \(deadline.formatted(date: .numeric, time: .omitted))")
                        }
                        if task.daysRepeat > 0 {
                            Text("Repite cada \(task.daysRepeat) días")
                        }
                    }
                }
                .font(.caption)
                HStack {
                    Text("Prioridad: \(task.priority.rawValue.capitalized)")
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    Label {
                        Text("Estado: \(task.state.rawValue.capitalized)")
                            .foregroundStyle(.secondary)
                    } icon: {
                        if task.state == .completed {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                        }
                    }
                }
                .font(.caption.bold())
            }
            .padding(.top, 2)
        } label: {
            TaskGroupBoxLabel(task: task)
        }
        .groupBoxStyle(TaskStyle(priority: task.priority))
        .accessibilityElement(children: .combine)
    }
}

struct TaskGroupBoxLabel: View {
    let task: ProjectTask
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: task.priority.icon)
                .foregroundStyle(task.priority.color)
            Text(task.name)
                .fontWeight(.semibold)
            if task.state == .completed {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.green)
            }
        }
    }
}

// MARK: - Color and Icon helpers (dummy for context)

extension ProjectType {
    var color: Color {
        switch self {
        case .development: return .blue
        case .design: return .pink
        case .marketing: return .orange
        case .education: return .yellow
        case .event: return .purple
        case .management: return .teal
        case .documentation: return .brown
        case .maintenance, .research, .support, .testing, .finance, .none: return .gray
        }
    }
    var icon: String {
        switch self {
        case .development: return "hammer.fill"
        case .design: return "paintpalette.fill"
        case .marketing: return "megaphone.fill"
        case .education: return "textbubble.bubble.fill"
        case .event: return "calendar.badge.fill"
        case .finance: return "dollarsign.circle.fill"
        case .management: return "pencil.and.ink.circle.fill"
        case .maintenance: return "wrench.circle.fill"
        case .documentation: return "book.circle.fill"
        case .research: return "magnifyingglass.circle.fill"
        case .support: return "envelope.fill"
        case .testing: return "testtube.fill"
        case .none: return "questionmark.circle.fill"
        }
    }
}

extension TaskPriority {
    var color: Color {
        switch self {
        case .high, .urgent: return .red
        case .medium: return .yellow
        case .low: return .green
        }
    }
    var icon: String {
        switch self {
        case .high, .urgent: return "exclamationmark.triangle.fill"
        case .medium: return "exclamationmark.circle.fill"
        case .low: return "arrow.down.right.circle.fill"
        }
    }
}

#Preview {
    NavigationStack {
        ProjectDetailView(project: .test)
    }
}
