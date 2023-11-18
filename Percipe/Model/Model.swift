//
//  Model.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import Foundation
import UIKit

@Observable
class Model {
    static let shared = Model()
    
    var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "onboarding.completed")
    
    var recipes: [Recipe] = []
    
    var discoverRecipes = [
        RecipeCardModel(id: UUID(), name: "Pasta Carbonara", preptime: Duration.seconds(10 * 60), pictures: [
            UIImage(named: "carbonara")!,
            UIImage(named: "carbonara2")!,
            UIImage(named: "carbonara")!,
            UIImage(named: "carbonara2")!,
            UIImage(named: "carbonara")!,
        ]),
        RecipeCardModel(id: UUID(), name: "Pasta Carbonara", preptime: Duration.seconds(10 * 60), pictures: [
            UIImage(named: "carbonara")!,
            UIImage(named: "carbonara2")!,
            UIImage(named: "carbonara")!,
            UIImage(named: "carbonara2")!,
            UIImage(named: "carbonara")!,
        ]),
    ]
    
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.setValue(true, forKey: "onboarding.completed")
    }
    
    init() {
        if let asset = NSDataAsset(name: "sample_data.json") {
            do {
                let decoder = JSONDecoder()
                Task { @MainActor in
                    self.recipes = try decoder.decode([Recipe].self, from: asset.data)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
    
}

@Observable
class UserPreferences {
    var allergies: [Allergy] = []
    var restrictions: [Restriction] = []
}

struct Allergy {
    let name: String
}

struct Restriction {
    let name: String
}
