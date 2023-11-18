//
//  ChipView.swift
//  Percipe
//
//  Created by Andreas Resch on 18.11.23.
//
import SwiftUI

struct ChipView: View {
    let titleKey: String

    var isSelected: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    func getBackground() -> Color {
        var color = colorScheme == .light ? Color.black : Color.gray;
        if isSelected {
            color = color.opacity(1)
        } else {
            color = color.opacity(0)
        }
        return color
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Text(titleKey).font(.body).lineLimit(1)
        }
        .padding(.vertical, 10)
        .padding(.leading, 15)
        .padding(.trailing, 15)
        .foregroundColor(colorScheme == .light ? .black : .white)
        .background(getBackground())
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(colorScheme == .light ? .gray : .white, lineWidth: 1.5)
        )
    }
}

#Preview {
    ChipView(titleKey: "Meat", isSelected: false)
}
