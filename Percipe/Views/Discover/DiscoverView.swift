//
//  DiscoverView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct DiscoverView: View {
    @Bindable
    var model = Model.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Discover")
                .font(.largeTitle)
                .padding()
            Spacer()
            SwipeView(recipes: $model.discoverRecipes, onSwiped: {_, _ in })
            Spacer()
        }
    }
}

#Preview {
    DiscoverView()
}
