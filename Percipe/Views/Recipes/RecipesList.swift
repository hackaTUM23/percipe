//
//  RecipesList.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct RecipesList: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(Model.shared.recipes, id: \.id) { recipe in
                    NavigationLink {
                        RecipeDetailView(recipe: recipe)
                    } label: {
                        RecipeCardView(recipe: recipe)
                            .padding([.top, .horizontal], 10)
                    }

                    
                }
            }.background(Color(uiColor: .secondarySystemBackground))
                .navigationTitle("Recipes")
        }
    }
}

#Preview {
    RecipesList()
}
