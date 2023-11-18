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
        1: "Easy",
        2: "Medium",
        3: "Challenging"
    ]
    
    init(recipe: Recipe) {
        self.recipe = recipe
        
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
                        Text(recipe.name)
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
                
                Text("Ingredients")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(recipe.ingredients, id: \.id) { ingredient in
                            IngredientTile(name: ingredient.name, amount: amounts[ingredient.id] ?? "", imageUrl: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3\(ingredient.imagePath ?? "")", isAllergy: self.model.userPreferences.allergies.contains(where: { ingredient.id == $0 }))
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
