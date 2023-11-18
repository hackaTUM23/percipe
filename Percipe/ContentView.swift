//
//  ContentView.swift
//  Percipe
//
//  Created by Andreas Resch on 18.11.23.
//

import SwiftUI

struct ContentView: View {
    var model = Model.shared
    
    var body: some View {
        if model.hasCompletedOnboarding {
            NavigationStack {
                HomeView()
            }
        } else {
            NavigationStack {
                WelcomeView()
            }
        }
    }
}

#Preview {
    ContentView()
}
