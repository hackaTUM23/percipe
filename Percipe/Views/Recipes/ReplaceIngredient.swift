//
//  ReplaceIngredient.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct ReplaceIngredient: View {
    let ingredient: RecipeIngredient
    let model = Model.shared
    
    var substitutions: [RecipeIngredient] {
        let all = self.ingredient.substitutions?.compactMap { subst in
            self.model.ingredients.first(where: { $0.id == subst })
        } ?? []
        
        var subst: [RecipeIngredient] = []
        var seen = Set<String>()
        
        for item in all {
            if seen.insert(item.name).inserted {
                subst.append(item)
            }
        }
        
        return subst
    }
    
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 100))
    ]
    
    var body: some View {
        ScrollView {
            Text("Select a replacement")
                .font(.title)

            VStack {
                IngredientTile(name: ingredient.name, amount: nil, imageUrl: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3\(ingredient.imagePath ?? "")", isAllergy: self.model.isAllergen(ingredient: ingredient), large: true)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(self.substitutions) { subst in
                        IngredientTile(name: subst.name, amount: nil, imageUrl: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3\(subst.imagePath ?? "")", isAllergy: self.model.isAllergen(ingredient: subst))
                    }
                }
            }
        }
    }
}

struct ReplaceIngredientPreview: View {
    let recipe: Recipe
    
    init() {
        let decoder = JSONDecoder()
        self.recipe = try! decoder.decode(Recipe.self, from: RecipeJson.data(using: .utf8)!)
    }
    
    var body: some View {
        ReplaceIngredient(ingredient: self.recipe.ingredients.first(where: { $0.id == "64df4828614f75555c20f3fa" })!)
    }
}


#Preview {
    // hazelnut
    ReplaceIngredientPreview()
}
