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
    
    var userPreferences: UserPreferences
    
    var recipes: [Recipe] = []
    
    var searchText: String = ""
    
    var allergens: [Allergen] = []
    var tags: [Tag] = []
    var ingredients: [RecipeIngredient] = []
    
    var discoverRecipes: [RecipeCardModel] = []
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.setValue(true, forKey: "onboarding.completed")
        persistUserPreferences()
    }
    
    func persistUserPreferences() {
        Task {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(userPreferences) {
                UserDefaults.standard.set(encoded, forKey: "userPreferences")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func getRecipeFrom(id: String) -> Recipe? {
        recipes.first {
            $0.id == id
        }
    }
    
    func addMatch(id: String) {
        if userPreferences.matchesId.contains(id) {
            return
        }
        userPreferences.matchesId.append(id)
        persistUserPreferences()
    }
    
    func toggleAllergy(id: String) {
        let index = userPreferences.allergies.firstIndex(of: id)
        if let index = index {
            userPreferences.allergies.remove(at: index)
        } else {
            userPreferences.allergies.append(id)
        }
        persistUserPreferences()
    }
    
    func toggleRestriction(id: String) {
        let index = userPreferences.restrictions.firstIndex(of: id)
        if let index = index {
            userPreferences.restrictions.remove(at: index)
        } else {
            userPreferences.restrictions.append(id)
        }
        persistUserPreferences()
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
        userPreferences = UserPreferences()
        if let data = UserDefaults.standard.object(forKey: "userPreferences") as? Data {
            let decoder = JSONDecoder()
            if let savedData = try? decoder.decode(UserPreferences.self, from: data) {
                self.userPreferences = savedData
            }
        }
        Task { @MainActor in
//            self.recipes = [getDataFromAssetsFor("sample_data.json").first!]
            self.recipes = getDataFromAssetsFor("sample_data.json")
            self.recipes.forEach { item in
                if self.discoverRecipes.count > 50 || self.userPreferences.matchesId.contains(item.id) {
                   return
                }
                var imagePaths: [String] = []
                if let initialImage = item.imagePath {
                    imagePaths.append(initialImage)
                }
                item.steps.forEach { step in
                    step.images.forEach { stepImage in
                        imagePaths.append(stepImage.path)
                    }
                }
                self.discoverRecipes.append(RecipeCardModel(id: item.id, name: item.name, preptime: item.prepTime.parseIso8601Interval(), pictures: imagePaths))
            }
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
        Task { @MainActor in
            self.ingredients = getDataFromAssetsFor("ingredients.json")
            print("Loaded \(self.ingredients.count) ingredients")
        }
    }
    
}

@Observable
class UserPreferences : Codable {
    var allergies: [String] = []
    var restrictions: [String] = []
    var matchesId: [String] = []
}
