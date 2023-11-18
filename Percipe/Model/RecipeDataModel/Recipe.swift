//
//  Recipe.swift
//  Percipe
//
//  Created by Leon Friedmann on 18.11.23.
//

import Foundation

class Recipe: Codable {
    var active: Bool
    var allergens: [Allergen]
    var averageRating: Double
    var cardLink: String?
    var country: Country
    var cuisines: [Cuisine]
    var description, descriptionHTML, descriptionMarkdown: String
    var difficulty, favoritesCount: Int
    var headline, id: String
    var imagePath: String?
    var ingredients: [RecipeIngredient]
    var isAddon: Bool
    var link: String
    var name: String
    var nutrition: [Nutrition]
    var prepTime: String
    var ratingsCount: Int
    var servingSize: Int
    var slug: String
    var steps: [Step]
    //var tags: [Tag]
    var totalTime: String
    var utensils: [Utensil]
    var uuid: String
    //var websiteURL: String
    var yields: [Yield]

    enum CodingKeys: String, CodingKey {
        case active, allergens, averageRating, cardLink, country, cuisines, description, descriptionHTML, descriptionMarkdown, difficulty, favoritesCount, headline, id, imagePath, ingredients, isAddon, link, name, nutrition, prepTime, ratingsCount, servingSize, slug, steps
        //case tags
        case totalTime, utensils, uuid
        case yields
    }

    init(active: Bool, allergens: [Allergen], averageRating: Double, cardLink: String?, country: Country, cuisines: [Cuisine], description: String, descriptionHTML: String, descriptionMarkdown: String, difficulty: Int, favoritesCount: Int, headline: String, id: String, imagePath: String?, ingredients: [RecipeIngredient], isAddon: Bool, link: String, name: String, nutrition: [Nutrition], prepTime: String, ratingsCount: Int, servingSize: Int, slug: String, steps: [Step], totalTime: String, utensils: [Utensil], uuid: String, yields: [Yield]) {
        self.active = active
        self.allergens = allergens
        self.averageRating = averageRating
        self.cardLink = cardLink
        self.country = country
        self.cuisines = cuisines
        self.description = description
        self.descriptionHTML = descriptionHTML
        self.descriptionMarkdown = descriptionMarkdown
        self.difficulty = difficulty
        self.favoritesCount = favoritesCount
        self.headline = headline
        self.id = id
        self.imagePath = imagePath
        self.ingredients = ingredients
        self.isAddon = isAddon
        self.link = link
        self.name = name
        self.nutrition = nutrition
        self.prepTime = prepTime
        self.ratingsCount = ratingsCount
        self.servingSize = servingSize
        self.slug = slug
        self.steps = steps
        //self.tags = tags
        self.totalTime = totalTime
        self.utensils = utensils
        self.uuid = uuid
        self.yields = yields
    }
}

// MARK: Recipe convenience initializers and mutators

extension Recipe {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Recipe.self, from: data)
        self.init(active: me.active, allergens: me.allergens, averageRating: me.averageRating, cardLink: me.cardLink, country: me.country, cuisines: me.cuisines, description: me.description, descriptionHTML: me.descriptionHTML, descriptionMarkdown: me.descriptionMarkdown, difficulty: me.difficulty, favoritesCount: me.favoritesCount, headline: me.headline, id: me.id, imagePath: me.imagePath, ingredients: me.ingredients, isAddon: me.isAddon, link: me.link, name: me.name, nutrition: me.nutrition, prepTime: me.prepTime, ratingsCount: me.ratingsCount, servingSize: me.servingSize, slug: me.slug, steps: me.steps, totalTime: me.totalTime, utensils: me.utensils, uuid: me.uuid, yields: me.yields)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        active: Bool? = nil,
        allergens: [Allergen]? = nil,
        averageRating: Double? = nil,
        cardLink: String? = nil,
        country: Country? = nil,
        cuisines: [Cuisine]? = nil,
        description: String? = nil,
        descriptionHTML: String? = nil,
        descriptionMarkdown: String? = nil,
        difficulty: Int? = nil,
        favoritesCount: Int? = nil,
        headline: String? = nil,
        id: String? = nil,
        imagePath: String? = nil,
        ingredients: [RecipeIngredient]? = nil,
        isAddon: Bool? = nil,
        link: String? = nil,
        name: String? = nil,
        nutrition: [Nutrition]? = nil,
        prepTime: String? = nil,
        ratingsCount: Int? = nil,
        servingSize: Int? = nil,
        slug: String? = nil,
        steps: [Step]? = nil,
        //tags: [Tag]? = nil,
        totalTime: String? = nil,
        
        utensils: [Utensil]? = nil,
        uuid: String? = nil,
        yields: [Yield]? = nil
    ) -> Recipe {
        return Recipe(
            active: active ?? self.active,
            allergens: allergens ?? self.allergens,
            averageRating: averageRating ?? self.averageRating,
            cardLink: cardLink ?? self.cardLink,
            country: country ?? self.country,
            cuisines: cuisines ?? self.cuisines,
            description: description ?? self.description,
            descriptionHTML: descriptionHTML ?? self.descriptionHTML,
            descriptionMarkdown: descriptionMarkdown ?? self.descriptionMarkdown,
            difficulty: difficulty ?? self.difficulty,
            favoritesCount: favoritesCount ?? self.favoritesCount,
            headline: headline ?? self.headline,
            id: id ?? self.id,
            imagePath: imagePath ?? self.imagePath,
            ingredients: ingredients ?? self.ingredients,
            isAddon: isAddon ?? self.isAddon,
            link: link ?? self.link,
            name: name ?? self.name,
            nutrition: nutrition ?? self.nutrition,
            prepTime: prepTime ?? self.prepTime,
            ratingsCount: ratingsCount ?? self.ratingsCount,
            servingSize: servingSize ?? self.servingSize,
            slug: slug ?? self.slug,
            steps: steps ?? self.steps,
            //tags: tags ?? self.tags,
            totalTime: totalTime ?? self.totalTime,
            utensils: utensils ?? self.utensils,
            uuid: uuid ?? self.uuid,
            yields: yields ?? self.yields
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
