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
        VStack {
            HStack {
                Spacer()
                Text("Please tell us about your dietary restrictions")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .foregroundStyle(Color.accentColor)
                Spacer()
            }.frame(height: 50)
                .background(Color(uiColor: .systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding()
            RestrictionsListView()
                .padding(.leading, 16)
                .navigationTitle("Dietary Restrictions")
                .navigationBarItems(trailing: Button("Done", action: {
                    model.completeOnboarding()
                }))
        }.background(Color(uiColor: .secondarySystemBackground))
    }
}

#Preview {
    NavigationStack {
        SelectRestrictionsView()
    }
}
