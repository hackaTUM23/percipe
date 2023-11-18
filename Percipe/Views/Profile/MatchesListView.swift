//
//  MatchesListView.swift
//  Percipe
//
//  Created by Andreas Resch on 18.11.23.
//

import SwiftUI

struct MatchesListView: View {
    
    var model: Model = Model.shared
    
    var body: some View {
        ScrollView {
            ForEach(model.userPreferences.matchesId.compactMap { item in
                model.getRecipeFrom(id: item)
            }, id: \.id) { match in
                RecipeCardView(recipe: match)
            }
        }.navigationTitle("Past matches")
    }
}
