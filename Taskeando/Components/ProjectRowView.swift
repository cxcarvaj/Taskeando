//
//  ProjectRowView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 24/5/25.
//

import SwiftUI

struct ProjectRowView: View {
    let project: Project
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationLink(destination: ProjectDetailView(project: project)) {
            HStack(spacing: 15) {
//                Circle()
//                    .fill(Color.blue)
//                    .frame(width: 12, height: 12)
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.name)
                        .font(.headline)
                    
                    HStack(spacing: 8) {
                        Label("\(project.tasks.count) tareas", systemImage: "checkmark.circle")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Label("\(project.users.count) Users", systemImage: "person.2.circle.fill")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        
                        //                        if let deadline = project.deadline {
                        //                            Label(deadline.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                        //                                .font(.caption)
                        //                                .foregroundStyle(.secondary)
                        //                        }
                    }
                    
                }
                
//                GroupBox {
//                    Aqui iba la vista
//                }
//                .groupBoxStyle(ProjectsStyle())
                
//                Spacer()
                
//                Text("\(project.completionPercentage ?? 0)%")
//                    .font(.callout.monospacedDigit())
//                    .bold()
//                    .foregroundStyle(project.completionPercentage == 100 ? .green : .primary)
            }
            .padding(.vertical, 8)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                // Eliminar proyecto
            } label: {
                Label("Eliminar", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                // Marcar como favorito
            } label: {
                Label("Favorito", systemImage: "star.fill")
            }
            .tint(.yellow)
        }
    }
}

#Preview {
    ProjectRowView(project: .test)
}
