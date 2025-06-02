//
//  TaskGroupBoxView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 31/5/25.
//

import SwiftUI

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
                            .foregroundStyle(.primary)
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

#Preview {
    @Previewable @State var task: ProjectTask = .test
    NavigationStack {
        TaskGroupBoxView(task: task)
    }
}
