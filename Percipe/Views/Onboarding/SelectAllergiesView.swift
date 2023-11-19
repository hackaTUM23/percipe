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
        VStack {
            HStack {
                Spacer()
                Text("Please tell us about your allergies")
                    .font(.headline)
                    .foregroundStyle(Color.accentColor)
                Spacer()
            }.frame(height: 50)
            .background(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding()
            AllergiesListView()
                .padding(.leading, 16)
                .navigationTitle("Allergies")
                .navigationBarItems(trailing: NavigationLink(destination: SelectRestrictionsView()) {
                    Label("Next", systemImage: "chevron.forward")
                })
        }.background(Color(uiColor: .secondarySystemBackground))
    }
}

#Preview {
    NavigationView {
        SelectAllergiesView()
    }
}
