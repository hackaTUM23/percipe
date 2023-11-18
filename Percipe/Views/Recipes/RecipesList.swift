//
//  RecipesList.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct RecipesList: View {
    
    @Bindable var model = Model.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(Model.shared.recipes.filter { model.searchText.count == 0 || $0.name.contains(model.searchText)}, id: \.id) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe)
                        } label: {
                            RecipeCardView(recipe: recipe)
                                .padding([.top, .horizontal], 10)
                        }   
                    }
                }
            }.background(Color(uiColor: .secondarySystemBackground))
                .navigationTitle("Recipes")
                .overlay {
                    if Model.shared.recipes.filter { model.searchText.count == 0 || $0.name.contains(model.searchText)}.isEmpty {
                                    /// In case there aren't any search results, we can
                                    /// show the new content unavailable view.
                                    ContentUnavailableView.search
                                }
                            }
        }.searchable(text: $model.searchText)
    }
}

#Preview {
    RecipesList()
}
