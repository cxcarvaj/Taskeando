//
//  TaskStyle.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 29/5/25.
//


import SwiftUI

struct TaskStyle: GroupBoxStyle {
    let priority: TaskPriority
    var cornerRadius: CGFloat = 12
    var shadowRadius: CGFloat = 7

    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            configuration.label
                .font(.headline)
                .foregroundStyle(.secondary)
            configuration.content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(priority.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(priority.borderColor, lineWidth: 1)
                )
                .shadow(color: priority.shadowColor, radius: shadowRadius, x: 0, y: 3)
        )
        .animation(.easeInOut(duration: 0.23), value: priority)
        .accessibilityElement(children: .combine)
    }
}

extension TaskPriority {
    var backgroundColor: Color {
        switch self {
        case .urgent: return Color.red.opacity(0.19)
        case .high:   return Color.orange.opacity(0.16)
        case .medium: return Color.yellow.opacity(0.13)
        case .low:    return Color.green.opacity(0.13)
        }
    }
    var borderColor: Color {
        switch self {
        case .urgent: return Color.red.opacity(0.36)
        case .high:   return Color.orange.opacity(0.32)
        case .medium: return Color.yellow.opacity(0.28)
        case .low:    return Color.green.opacity(0.25)
        }
    }
    var shadowColor: Color {
        switch self {
        case .urgent: return Color.red.opacity(0.13)
        case .high:   return Color.orange.opacity(0.12)
        case .medium: return Color.yellow.opacity(0.10)
        case .low:    return Color.green.opacity(0.10)
        }
    }
}
