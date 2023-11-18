//
//  RecipeDetailView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var amounts: [String: String] = [:]
    let difficulties = [
        "Easy",
        "Medium",
        "Challenging"
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
                
                HStack {
                    Label("Easy", systemImage: "frying.pan")
                    Label("25 min", systemImage: "clock")
                }
                .foregroundColor(.blue)
                .padding(.horizontal)
                
                Text("Ingredients")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(recipe.ingredients, id: \.id) { ingredient in
                            IngredientTile(name: ingredient.name, amount: amounts[ingredient.id] ?? "", imageUrl: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3\(ingredient.imagePath ?? "")")
                        }
                    }
                    .padding(.horizontal)
                }
                
                Text("Instructions")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding()

                ForEach(recipe.steps, id: \.index) { step in
//                    let str: LocalizedStringKey = step.instructionsMarkdown
                    Text("\(step.index). \(step.instructionsMarkdown)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.horizontal)

                    
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
