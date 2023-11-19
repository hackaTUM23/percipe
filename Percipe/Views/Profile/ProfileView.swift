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
        
    var favoriteIngredients: [RecipeIngredient] {
        Array(Dictionary(grouping: model.userPreferences.matchesId
            .compactMap { model.getRecipeFrom(id: $0) }
            .flatMap(\.ingredients), by: { $0.id })
            .sorted(by: {$0.value.count < $1.value.count})
            .compactMap { model.getIngredientBy($0.key)}
            .filter { !model.isAllergen(ingredient: $0)}
            .prefix(3))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    ProfilePictureView()
                }
                .background(Color(uiColor: .systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding([.top, .horizontal])
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Edit Allergies", systemImage: "allergens") {
                            showAllergensSheet.toggle()
                        }.frame(height: 40)
                            .padding(.leading)
                        Spacer()
                        Image(systemName: "chevron.forward").foregroundStyle(Color.accentColor)
                            .padding(.trailing)
                    }
                    Divider()
                    HStack(alignment: .center) {
                        Button("Diet restrictions", systemImage: "figure.wrestling") {
                            showRestrictionSheet.toggle()
                        }.frame(height: 40)
                            .padding(.leading)
                        Spacer()
                        Image(systemName: "chevron.forward").foregroundStyle(Color.accentColor)
                            .padding(.trailing)
                    }
                    Divider()
                    HStack {
                        NavigationLink {
                            MatchesListView()
                        } label: {
                            Label(model.userPreferences.matchesId.count.description + " past matches", systemImage: "heart.fill")
                        }.frame(height: 40)
                            .padding(.leading)
                        Spacer()
                        Image(systemName: "chevron.forward").foregroundStyle(Color.accentColor)
                            .padding(.trailing)
                    }
                }.background(Color(uiColor: .systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding([.top, .horizontal])
                VStack {
                    Text("Favorite Ingredients")
                        .font(.headline)
                        .padding([.horizontal, .top])
                    HStack {
                        Spacer()
                        ForEach(favoriteIngredients, id: \.id) { ingredient in
                            IngredientTile(name: ingredient.name, amount: nil, imageUrl: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3\(ingredient.imagePath ?? "")", isAllergy: model.isAllergen(ingredient: ingredient))
                                .padding([.vertical])
                        }
                        Spacer()
                    }
                }.background(Color(uiColor: .systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding([.top, .horizontal])
                Spacer()
            }
            .navigationTitle("Profil")
            .background(Color(uiColor: .systemGroupedBackground))
            .sheet(isPresented: $showAllergensSheet) {
                NavigationView {
                    AllergiesListView().navigationTitle("Your allergies")
                }
            }
            .sheet(isPresented: $showRestrictionSheet) {
                NavigationView {
                    RestrictionsListView().navigationTitle("Your dietary restrictions")
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
