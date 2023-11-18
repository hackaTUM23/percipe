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
    
    func parseIso8601Interval(duration: String) -> Duration {
        var duration = duration
        if duration.hasPrefix("PT") { duration.removeFirst(2) }
        let hour, minute, second: Double
        if let index = duration.firstIndex(of: "H") {
            hour = Double(duration[..<index]) ?? 0
            duration.removeSubrange(...index)
        } else { hour = 0 }
        if let index = duration.firstIndex(of: "M") {
            minute = Double(duration[..<index]) ?? 0
            duration.removeSubrange(...index)
        } else { minute = 0 }
        if let index = duration.firstIndex(of: "S") {
            second = Double(duration[..<index]) ?? 0
        } else { second = 0 }
        
        return Duration.seconds(second + minute * 60 + hour * 3600)
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
                
                let durationMins = parseIso8601Interval(duration: recipe.prepTime)
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
                    
                    Text(step.instructions)
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
