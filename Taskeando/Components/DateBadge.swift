//
//  DateBadge.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 2/6/25.
//

import SwiftUI

struct DateBadge: View {
    let date: Date
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            Text(month)
                .font(.caption2)
                .fontWeight(.bold)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(4)
            
            Text(day)
                .font(.title3)
                .fontWeight(.medium)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white)
                .cornerRadius(4)
                .foregroundColor(.black)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.red, lineWidth: 1)
        )
        .accessibilityLabel("Fecha límite: \(formattedDate)")
    }
    
    private var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date).uppercased()
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

#Preview {
    DateBadge(date: .now)
}
