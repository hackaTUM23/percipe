//
//  SelectAllergiesView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct SelectAllergiesView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("asdasd")
            }
        }
        .navigationTitle("Allergies")
        .navigationBarItems(trailing: NavigationLink(destination: SelectRestrictionsView()) {
            Label("Next", systemImage: "chevron.forward")
        })
    }
}

#Preview {
    NavigationView {
        SelectAllergiesView()
    }
}
