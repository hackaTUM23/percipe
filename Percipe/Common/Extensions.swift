//
//  Extensions.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View {
    public func foregroundGradient(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
    }
}

extension String {
    func parseIso8601Interval() -> Duration {
        var duration = self
        if duration.hasPrefix("PT") { duration.removeFirst(2) }
        let hour, minute, second: Double
        if let index = duration.firstIndex(of: "H") {
            hour = Double(duration[..<index]) ?? 0
            duration.removeSubrange(...index)
        } else { hour = 0 }
        if let index = duration.firstIndex(of: "M") {
            minute = Double(duration[..<index]) ?? 0
            duration.removeSubrange(...index)
        } else { minute = 0 }
        if let index = duration.firstIndex(of: "S") {
            second = Double(duration[..<index]) ?? 0
        } else { second = 0 }
        
        return Duration.seconds(second + minute * 60 + hour * 3600)
    }
}
