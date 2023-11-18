//
//  SelectAllergiesView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct SelectAllergiesView: View {
    
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
    
    private func generateContent(in g: GeometryProxy) -> some View {
            var width = CGFloat.zero
            var height = CGFloat.zero

            return ZStack(alignment: .topLeading) {
                ForEach(mockAllergies, id: \.self) { item in
                    ChipView(titleKey: item, isSelected: false)
                        .padding([.horizontal, .vertical], 4)
                        .alignmentGuide(.leading, computeValue: { d in
                            if (abs(width - d.width) > g.size.width)
                            {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if item == mockAllergies.last! {
                                width = 0 //last item
                            } else {
                                width -= d.width
                            }
                            return result
                        })
                        .alignmentGuide(.top, computeValue: {d in
                            let result = height
                            if item == mockAllergies.last! {
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
        .navigationTitle("Allergies")
        .navigationBarItems(trailing: NavigationLink(destination: SelectRestrictionsView()) {
            Label("Next", systemImage: "chevron.forward")
        })
    }

//    var body: some View {
//        ScrollView {
//            LazyVGrid(
//                columns: [
//                    GridItem(.adaptive(minimum: 50, maximum: size)),
//                ],
//                spacing: padding)
//            {
//                ForEach(mockAllergies, id: \.self) {
//                    ChipView(titleKey: $0, isSelected: false, selectedColor: .red)
//                }
//            }.padding(padding)
//        }
//        .navigationTitle("Allergies")
//        .navigationBarItems(trailing: NavigationLink(destination: SelectRestrictionsView()) {
//            Label("Next", systemImage: "chevron.forward")
//        })
//    }
}

#Preview {
    NavigationView {
        SelectAllergiesView()
    }
}
