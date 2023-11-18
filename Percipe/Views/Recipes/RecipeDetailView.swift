//
//  RecipeDetailView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct RecipeDetailView: View {
    let model = Model.shared
    
    let recipe: Recipe
    
    var amounts: [String: String] = [:]
    let difficulties = [
        1: "Leicht",
        2: "Mittel",
        3: "Anspruchsvoll"
    ]
    
    @State var replaceIngredient: RecipeIngredient? = nil
    @State var ingredientsStorage: [RecipeIngredient]
    
    var ingredients: [(RecipeIngredient, Bool)] {
        ingredientsStorage.map { ingredient in
            return (ingredient, self.model.isAllergen(ingredient: ingredient))
        }
    }
    
    var allergyExists: Bool {
        ingredients.contains(where: { $0.1 })
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
        self.ingredientsStorage = recipe.ingredients
        
        if let yields = recipe.yields.first {
            for amount in yields.ingredients {
                var str = ""
                if let amount = amount.amount {
                    str = String(format: "%.0f ", amount)
                }
                str += amount.unit
                
                amounts[amount.id] = str
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(
                        url: URL(string: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3\(recipe.imagePath ?? "")"),
                        content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                        },
                        placeholder: {
                            ZStack {
                                ProgressView()
                            }
                            .frame(maxWidth: 100)
                            .frame(height: 200)
                        }
                    )
                    VStack {
                        Spacer()
                            .frame(height: 40)
                        HStack {
                            Text(recipe.name)
                            Spacer()
                        }
                    }
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(colors: [
                        Color.black.opacity(0.0),
                        Color.black.opacity(0.4),
                    ], startPoint: .top, endPoint: .bottom))
                }
                
                JustifiedLabel(text: recipe.description)
                    .padding(.horizontal)
                
                let durationMins = recipe.prepTime.parseIso8601Interval()
                
                HStack {
                    Label(difficulties[recipe.difficulty] ?? "Easy", systemImage: "frying.pan")
                    Label("\(durationMins.components.seconds / 60) min", systemImage: "clock")
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Ingredients")
                    if allergyExists {
                        Image(systemName: "allergens")
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    }
                }
                .font(.title3)
                .fontWeight(.semibold)
                .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(ingredients, id: \.0.id) { (ingredient, isAllergy) in
                            IngredientTile(name: ingredient.name, amount: amounts[ingredient.id] ?? "", imageUrl: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3\(ingredient.imagePath ?? "")", isAllergy: isAllergy)
                                .onTapGesture {
                                    self.replaceIngredient = ingredient
                                }
                                .opacity(ingredient.disabled == true ? 0.5 : 1)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Text("Instructions")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding()
                
                ForEach(recipe.steps, id: \.index) { step in
                    if let image = step.images.first {
                        ZStack(alignment: .topLeading) {
                            AsyncImage(
                                url: URL(string: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3\(image.path)"),
                                content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                },
                                placeholder: {
                                    ZStack {
                                        ProgressView()
                                    }
                                    .frame(maxWidth: 100)
                                    .frame(height: 200)
                                }
                            )
                            
                            Text("\(step.index). \(image.caption)")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.top, 10)
                                .padding(.horizontal)
                        }
                    } else {
                        Text("\(step.index)")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.top)
                            .padding(.horizontal)
                    }
                    
                    JustifiedLabel(text: step.instructions)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .sheet(item: $replaceIngredient, content: { ingredient in
            ReplaceIngredient(ingredient: self.model.ingredients.first(where: { $0.id == ingredient.id })!, onReplace: { replacement in
                let index = self.ingredientsStorage.firstIndex(where: { $0.id == ingredient.id })!
                self.ingredientsStorage[index] = replacement
                
                self.replaceIngredient = nil
            })
        })
    }
}

struct RecipeDetailPreview: View {
    let recipe: Recipe
    
    init() {
        let decoder = JSONDecoder()
        self.recipe = try! decoder.decode(Recipe.self, from: RecipeJson.data(using: .utf8)!)
    }
    
    var body: some View {
        RecipeDetailView(recipe: recipe)
    }
}

#Preview {
    NavigationStack {
        RecipeDetailPreview()
    }
}
