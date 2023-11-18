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
    var distinctAllergens: [Allergen] = []
    var tags: [Tag] = []
    var distinctTags: [Tag] = []
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
        var indicesToToggle: [Int] = []
        var idsToAppend: [String] = []
        let item = allergens.first {
            $0.id == id
        }
        if let item = item {
            let sameNames = allergens.filter {
                $0.name == item.name
            }
            sameNames.forEach { candidate in
                idsToAppend.append(candidate.id)
                if let index = userPreferences.allergies.firstIndex(of: candidate.id) {
                    indicesToToggle.append(index)
                }
            }
        }
        let sorted = indicesToToggle.sorted(by: { $0 > $1 })
        if let index = index {
            sorted.forEach {
                userPreferences.allergies.remove(at: $0)
            }
        } else {
            idsToAppend.forEach {
                userPreferences.allergies.append($0)
            }
        }
        persistUserPreferences()
    }
    
    func toggleRestriction(id: String) {
        let index = userPreferences.restrictions.firstIndex(of: id)
        var indicesToToggle: [Int] = []
        var idsToAppend: [String] = []
        let item = tags.first {
            $0.id == id
        }
        if let item = item {
            let sameNames = tags.filter {
                $0.name == item.name
            }
            sameNames.forEach { candidate in
                idsToAppend.append(candidate.id)
                if let index = userPreferences.restrictions.firstIndex(of: candidate.id) {
                    indicesToToggle.append(index)
                }
            }
        }
        let sorted = indicesToToggle.sorted(by: { $0 > $1 })
        if let index = index {
            sorted.forEach {
                userPreferences.restrictions.remove(at: $0)
            }
        } else {
            idsToAppend.forEach {
                userPreferences.restrictions.append($0)
            }
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
    
    func isAllergen(ingredient: RecipeIngredient) -> Bool {
        print("ingredient")
        print(ingredient.allergens)
        print("user")
        print(self.userPreferences.allergies)
        return ingredient.disabled != true && ingredient.allergens.contains(where: { allergen in
            self.userPreferences.allergies.contains(where: { allergen == $0 })
        })
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
            self.distinctAllergens = []
            self.allergens.forEach { all in
                let alreadyIn = distinctAllergens.contains {
                    $0.name == all.name
                }
                if !alreadyIn {
                    distinctAllergens.append(all)
                }
            }
            print("Loaded \(self.allergens.count) allergens")
        }
        Task { @MainActor in
            self.tags = getDataFromAssetsFor("tags.json")
            self.distinctTags = []
            self.tags.forEach { all in
                let alreadyIn = distinctTags.contains {
                    $0.name == all.name
                }
                if !alreadyIn {
                    distinctTags.append(all)
                }
            }
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
