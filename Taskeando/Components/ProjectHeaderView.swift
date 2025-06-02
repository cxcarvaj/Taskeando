//
//  ProjectHeaderView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 31/5/25.
//

import SwiftUI

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
                    content: ProjectPicker(projectType: $detailVM.type, isEditable: false)
                )
                ProjectPropertyView(
                    icon: "flag.fill",
                    label: "Estado",
                    content: StatePicker(taskState: $detailVM.state, isEditable: false)
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

#Preview {
    @Previewable @State var vm: ProjectDetailVM = ProjectDetailVM()
    NavigationStack {
        ProjectHeaderView(project: .test, detailVM: $vm)
    }
}
