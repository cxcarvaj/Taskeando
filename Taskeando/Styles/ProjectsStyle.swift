//
//  ProjectsStyle.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 30/5/25.
//

import SwiftUI

struct ProjectsStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.headline)
                .foregroundStyle(.secondary)
            configuration.content
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGroupedBackground))
                .shadow(color: .primary.opacity(0.4), radius: 5, x: 0, y: 5)
        }
        .padding()
    }
}
