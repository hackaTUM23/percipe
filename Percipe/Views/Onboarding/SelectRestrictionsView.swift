//
//  SelectRestrictionsView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct SelectRestrictionsView: View {
    
    var model = Model.shared
    
    var body: some View {
        RestrictionsListView()
        .padding(.leading, 16)
        .navigationTitle("Dietary Restrictions")
        .navigationBarItems(trailing: Button("Done", action: {
            model.completeOnboarding()
        }))
    }
}

#Preview {
    NavigationStack {
        SelectRestrictionsView()
    }
}
