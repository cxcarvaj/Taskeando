//
//  ProjectPicker.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 29/5/25.
//

import SwiftUI

struct ProjectPicker: View {
    @Binding var projectType: ProjectType
    var isEditable: Bool = true
    
    var body: some View {
        if isEditable {
            Picker("Tipo de proyecto", selection: $projectType) {
                ForEach(ProjectType.allCases) { type in
                    Text(type.rawValue.capitalized)
                        .tag(type)
                }
            }
            .accessibilityLabel("Tipo de proyecto: \(projectType.rawValue.capitalized)")
        } else {
            Text(projectType.rawValue.capitalized)
                .font(.caption)
                .accessibilityLabel("Tipo de proyecto: \(projectType.rawValue.capitalized)")
        }
    }
}

#Preview("Picker Editable") {
    @Previewable @State var projectType: ProjectType = .allCases.first!
    ProjectPicker(projectType: $projectType)
}

#Preview("Picker Not Editable") {
    @Previewable @State var projectType: ProjectType = .allCases.first!
    ProjectPicker(projectType: $projectType, isEditable: false)
}
