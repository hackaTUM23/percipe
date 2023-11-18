//
//  HomeView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct HomeView: View {
    @State private var selection = 1
    
    var body: some View {
        TabView(selection: $selection) {
            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
                .tag(0)
            RecipesList()
                .tabItem {
                    Label("Recipes", systemImage: "list.bullet")
                }
                .tag(1)
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(2)
        }.toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    HomeView()
}
