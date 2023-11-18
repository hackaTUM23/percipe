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
    private init() {}
    
    static let shared = Model()
    
    var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "onboarding.completed")
    
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
