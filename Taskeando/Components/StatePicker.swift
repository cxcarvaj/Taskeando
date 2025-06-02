//
//  StatePicker.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 29/5/25.
//

import SwiftUI

struct StatePicker: View {
    @Binding var taskState: TaskState
    var isEditable: Bool = true

    var body: some View {
        if isEditable {
            Picker("Estado actual", selection: $taskState) {
                ForEach(TaskState.allCases) { state in
                    Text(state.rawValue.capitalized)
                        .tag(state)
                }
            }
            .accessibilityLabel("Estado del proyecto: \(taskState.rawValue.capitalized)")
        } else {
            Text(taskState.rawValue.capitalized)
                .font(.caption)
                .accessibilityLabel("Estado del proyecto: \(taskState.rawValue.capitalized)")
        }
    }
}

#Preview("Picker Editable") {
    @Previewable @State var taskState: TaskState = .active
    StatePicker(taskState: $taskState)
}

#Preview("Picker Not Editable") {
    @Previewable @State var taskState: TaskState = .active
    StatePicker(taskState: $taskState, isEditable: false)
}
