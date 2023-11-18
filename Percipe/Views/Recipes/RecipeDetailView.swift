//
//  RecipeDetailView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: RecipeCardModel
    
    var body: some View {
        //GeometryReader { geometry in
        ScrollView {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomLeading) {
                    Image(uiImage: recipe.pictures[0])
                        .resizable()
                        .scaledToFit()
                    VStack {
                        Spacer()
                            .frame(height: 40)
                        Text(recipe.name)
                    }
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(colors: [
                        Color.black.opacity(0.0),
                        Color.black.opacity(0.4),
                    ], startPoint: .top, endPoint: .bottom))
                }
                
                JustifiedLabel(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                    .padding(.horizontal)

                HStack {
                    Label("Easy", systemImage: "frying.pan")
                    Label("25 min", systemImage: "clock")
                }
                .foregroundColor(.blue)
                .padding(.horizontal)
                
                Text("Ingredients")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding()
                
                Text("Here come the ingredients")
                    .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(
            recipe: RecipeCardModel(id: UUID(), name: "Creamy mushroom soup", preptime: Duration.seconds(10 * 60), pictures: [
                UIImage(named: "mushroom-soup")!,
            ])
        )
    }
}
