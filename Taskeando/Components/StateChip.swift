//
//  StateChip.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 2/6/25.
//

import SwiftUI

struct StateChip: View {
    let state: TaskState
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(stateColor)
                .frame(width: 10, height: 10)
            Text(state.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(stateColor.opacity(0.15))
        .cornerRadius(16)
        .accessibilityLabel("Estado: \(state.rawValue)")
    }
    
    private var stateColor: Color {
        switch state {
        case .pending, .inactive, .onHold, .none:
            return .gray
        case .active:
            return .blue
        case .completed:
            return .green
        case .cancelled:
            return .orange
        }
    }
}

#Preview {
    StateChip(state: .active)
}
