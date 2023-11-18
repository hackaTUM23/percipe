//
//  WelcomeView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            NavigationLink("Get Started", destination: SelectAllergiesView())
        }
        .navigationTitle("Welcome")
    }
}

#Preview {
    WelcomeView()
}
