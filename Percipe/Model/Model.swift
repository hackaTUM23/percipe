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
    var allergens: [Allergen] = []
    var tags: [Tag] = []
    
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
    
    private func getDataFromAssetsFor<T: Codable>(_ fileName: String) -> [T] {
        if let asset = NSDataAsset(name: fileName) {
            do {
                let decoder = JSONDecoder()
                    return try decoder.decode([T].self, from: asset.data)
            } catch {
                print("\(T.Type.self) Error decoding JSON: \(error) ")
            }
        }
        return []
    }
    
    init() {
        
        Task { @MainActor in
            self.recipes = getDataFromAssetsFor("sample_data.json")
            print("Loaded \(self.recipes.count) recipes")
        }
        Task { @MainActor in
            self.allergens = getDataFromAssetsFor("allergens.json")
            print("Loaded \(self.allergens.count) allergens")
        }
        Task { @MainActor in
            self.tags = getDataFromAssetsFor("tags.json")
            print("Loaded \(self.tags.count) tags")
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
