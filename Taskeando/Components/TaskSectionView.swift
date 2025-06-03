//
//  TaskSectionView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 31/5/25.
//

import SwiftUI

struct TaskSectionView: View {
    let tasks: [ProjectTask]
    var onAdd: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Tareas")
                    .font(.title3)
                    .bold()
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
                        NavigationLink(destination: TaskDetailView(task: task)) {
                            TaskGroupBoxView(task: task)
                        }
                        .buttonStyle(PlainButtonStyle())
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

#Preview {
    TaskSectionView(tasks: [.test, .test], onAdd: {})
}
