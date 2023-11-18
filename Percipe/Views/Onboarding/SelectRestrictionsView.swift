//
//  SelectRestrictionsView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI
import CoreHaptics

struct SelectRestrictionsView: View {
    var model = Model.shared
    
    private func onTap(item: String) {
        withAnimation {
            let index = model.userPreferences.restrictions.firstIndex(of: item)
            if let index = index {
                model.userPreferences.restrictions.remove(at: index)
            } else {
                model.userPreferences.restrictions.append(item)
            }
            hapticFeedback()
        }
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(model.tags, id: \.id) { item in
                ChipView(titleKey: item.name, isSelected: model.userPreferences.restrictions.contains{
                    $0 == item.id
                }).onTapGesture {
                    onTap(item: item.id)
                }
                .padding([.horizontal, .vertical], 4)
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width - d.width) > g.size.width)
                    {
                        width = 0
                        height -= d.height
                    }
                    let result = width
                    if item.id == model.tags.last!.id {
                        width = 0 //last item
                    } else {
                        width -= d.width
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: {d in
                    let result = height
                    if item.id == model.tags.last!.id {
                        height = 0 // last item
                    }
                    return result
                })
            }
        }
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                self.generateContent(in: geometry)
            }
        }.padding(.leading, 16)
            .navigationTitle("Dietary Restrictions")
        .navigationBarItems(trailing: Button("Done", action: {
            model.completeOnboarding()
        }))
    }
    
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
}

#Preview {
    NavigationStack {
        SelectRestrictionsView()
    }
}
