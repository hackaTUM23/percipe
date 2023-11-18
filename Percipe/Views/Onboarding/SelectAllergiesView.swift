//
//  SelectAllergiesView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI
import CoreHaptics

struct SelectAllergiesView: View {
    
    var model: Model = Model.shared
    
    var mockAllergies = [
        "Meat",
        "People",
        "Apples",
        "Oranges",
        "Bananas",
        "Coffeine",
        "Vegetables",
        "Butter",
        "Milk",
        "Something",
        "idk",
        "what",
        "why"
    ]
    
    private func onTap(item: String) {
        withAnimation {
            let index = model.userPreferences.allergies.firstIndex(of: item)
            if let index = index {
                model.userPreferences.allergies.remove(at: index)
            } else {
                model.userPreferences.allergies.append(item)
            }
            hapticFeedback()
        }
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
            var width = CGFloat.zero
            var height = CGFloat.zero

            return ZStack(alignment: .topLeading) {
                ForEach(model.allergens, id: \.id) { item in
                    ChipView(titleKey: item.name, isSelected: model.userPreferences.allergies.contains{
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
                        if item.id == model.allergens.last!.id {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if item.id == model.allergens.last!.id {
                            height = 0 // last item
                        }
                        return result
                    })
                }
            }
        }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                self.generateContent(in: geometry)
            }
        }.padding(.leading, 16)
        .navigationTitle("Allergies")
        .navigationBarItems(trailing: NavigationLink(destination: SelectRestrictionsView()) {
            Label("Next", systemImage: "chevron.forward")
        })
        .onAppear {
            prepareHaptics()
        }
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
    NavigationView {
        SelectAllergiesView()
    }
}
