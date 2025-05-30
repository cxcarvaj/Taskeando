//
//  ProjectPicker.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 29/5/25.
//

import SwiftUI

struct ProjectPicker: View {
    @Binding var projectType: ProjectType
    
    var body: some View {
        Picker("Tipo de proyecto", selection: $projectType) {
            ForEach(ProjectType.allCases) { type in
                Text(type.rawValue.capitalized)
                    .tag(type)
            }
        }
        .accessibilityLabel("Tipo de proyecto")
    }
}

#Preview {
    @Previewable @State var projectType: ProjectType = .allCases.first!
    ProjectPicker(projectType: $projectType)
}
