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
        ScrollView {
            VStack {
                Text("asdasd")
            }
        }
        .navigationTitle("Restrictions")
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
