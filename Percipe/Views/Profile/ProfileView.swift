//
//  ProfileView.swift
//  Percipe
//
//  Created by Andreas Resch on 18.11.23.
//

import SwiftUI

struct ProfileView: View {
    
    var model: Model = Model.shared
    
    @State private var showAllergensSheet = false
    @State private var showRestrictionSheet = false
    
    func getNameOfAllergies(id: String) -> Allergen? {
        model.allergens.first(where: {
            $0.id == id
        })
    }
        
    var body: some View {
        VStack {
            HStack {
                ProfilePictureView().padding(.leading, 4)
            }
            HStack {
                Button("Edit Allergies", systemImage: "allergens") {
                    showAllergensSheet.toggle()
                }
                
                Button("Diet restrictions", systemImage: "figure.wrestling") {
                    showRestrictionSheet.toggle()
                }
            }
            .padding(.top, 16)
            Spacer()
        }
        .sheet(isPresented: $showAllergensSheet) {
            NavigationView {
                SelectAllergiesView()
            }
        }
        .sheet(isPresented: $showRestrictionSheet) {
            NavigationView {
                SelectRestrictionsView()
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ProfileView()
}
