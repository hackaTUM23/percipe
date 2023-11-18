//
//  ChipView.swift
//  Percipe
//
//  Created by Andreas Resch on 18.11.23.
//

import CoreHaptics
import SwiftUI

struct ChipView: View {
    let titleKey: String
    @State var isSelected: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var engine: CHHapticEngine?
    
    
    func hapticFeedback() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
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
            
        ).onTapGesture {
            withAnimation {
                isSelected.toggle()
                hapticFeedback()
            }
        }
        .onAppear {
            prepareHaptics()
        }
    }
}

#Preview {
    ChipView(titleKey: "Meat", isSelected: false)
}
