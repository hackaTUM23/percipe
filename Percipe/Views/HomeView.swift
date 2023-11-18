//
//  HomeView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
            RecipesList()
                .tabItem {
                    Label("Recipes", systemImage: "list.bullet")
                }
        }
    }
}

#Preview {
    HomeView()
}
