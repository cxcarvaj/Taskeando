//
//  StatePicker.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 29/5/25.
//

import SwiftUI

struct StatePicker: View {
    @Binding var taskState: TaskState

    var body: some View {
        Picker("Estado actual", selection: $taskState) {
            ForEach(TaskState.allCases) { state in
                Text(state.rawValue.capitalized)
                    .tag(state)
            }
        }
        .accessibilityLabel("Estado del proyecto")
    }
}

#Preview {
    @Previewable @State var taskState: TaskState = .active
    StatePicker(taskState: $taskState)
}
