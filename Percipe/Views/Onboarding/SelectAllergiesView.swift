//
//  SelectAllergiesView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI
import CoreHaptics

struct SelectAllergiesView: View {
    
    var model: Model = Model.shared
    
    var body: some View {
        AllergiesListView()
        .padding(.leading, 16)
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
