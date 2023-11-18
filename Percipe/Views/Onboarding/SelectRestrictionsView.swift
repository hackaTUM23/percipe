//
//  SelectRestrictionsView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct SelectRestrictionsView: View {
    var model = Model.shared
    
    var mockRestrictions = [
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
    
    
    private func generateContent(in g: GeometryProxy) -> some View {
            var width = CGFloat.zero
            var height = CGFloat.zero

            return ZStack(alignment: .topLeading) {
                ForEach(mockRestrictions, id: \.self) { item in
                    ChipView(titleKey: item, isSelected: false)
                        .padding([.horizontal, .vertical], 4)
                        .alignmentGuide(.leading, computeValue: { d in
                            if (abs(width - d.width) > g.size.width)
                            {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if item == mockRestrictions.last! {
                                width = 0 //last item
                            } else {
                                width -= d.width
                            }
                            return result
                        })
                        .alignmentGuide(.top, computeValue: {d in
                            let result = height
                            if item == mockRestrictions.last! {
                                height = 0 // last item
                            }
                            return result
                        })
                }
            }
        }
    
    
    var body: some View {
        ScrollView(.vertical) {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .navigationTitle("Restrictions")
        .navigationBarItems(trailing: Button("Done", action: {
            model.completeOnboarding()
        }))
    }
}

#Preview {
    NavigationStack {
        SelectRestrictionsView()
    }
}
