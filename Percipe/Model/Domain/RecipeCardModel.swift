//
//  RecipeCardModel.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import Foundation
import UIKit

struct RecipeCardModel: Identifiable {
    let id: String
    let name: String
    let preptime: Duration
    let pictures: [String]
}
