//
//  RecipeCardView.swift
//  Percipe
//
//  Created by Leon Friedmann on 18.11.23.
//

import SwiftUI

struct RecipeCardView: View {
    
    let recipe: Recipe
    let difficulties = [
        1: "Leicht",
        2: "Mittel",
        3: "Schwer"
    ]
    
    var userAlergic: Bool {
        recipe.ingredients.first(where: { Model.shared.isAllergen(ingredient: $0) })
        != nil
    }
    
    var body: some View {
        HStack {
            ZStack {
                AsyncImage(
                    url: URL(string: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3\(recipe.imagePath ?? "")"),
                    content: { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 130)
                            .clipShape(Rectangle())
                            .aspectRatio(contentMode: .fill)
                    },
                    placeholder: {
                        ZStack {
                            ProgressView()
                        }
                        .frame(width: 150, height: 130)
                    }
                )
            }
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .multilineTextAlignment(.leading)
                let durationMins = recipe.prepTime.parseIso8601Interval()
                Spacer()
                HStack {
                    Label(difficulties[recipe.difficulty] ?? "Easy", systemImage: "frying.pan")
                    Spacer()
                    Label("\(durationMins.components.seconds / 60) min", systemImage: "clock")
                }
                .foregroundStyle(.secondary)
                Spacer()
                HStack {
                    if self.userAlergic {
                        
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.red)
                            .font(.title)
                        Spacer()
                    }
                    
                    ForEach(recipe.allergens.filter {$0.iconPath != nil }, id: \.id) { allergen in
                        AsyncImage(
                            url: URL(string: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3\(allergen.iconPath ?? "")"),
                            content: { image in
                                image.resizable()
                                
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 25, height: 25)
                                
                                
                                
                            },
                            placeholder: {
                                ZStack {
                                    ProgressView()
                                }
                                .frame(width: 25, height: 25)
                            }
                        )
                    }
                }
            }.padding([.top, .bottom, .trailing], 10)
        }
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15.0))
        .frame(maxHeight: 130)
        .shadow(radius: 5)
    }
}

struct RecipeCardViewPreview: View {
    let recipe: Recipe
    
    init() {
        let decoder = JSONDecoder()
        self.recipe = try! decoder.decode(Recipe.self, from: RecipeJson.data(using: .utf8)!)
    }
    
    var body: some View {
        RecipeCardView(recipe: recipe)
    }
}

#Preview {
    RecipeCardViewPreview()
        .background(Color(uiColor: UIColor.tertiarySystemGroupedBackground))
}
