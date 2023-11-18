//
//  RecipeIngredient.swift
//  Percipe
//
//  Created by Leon Friedmann on 18.11.23.
//

import Foundation

class RecipeIngredient: Codable {
    var id, uuid, name, type: String
    var slug: String
    var country: Country
    var imagePath: String?
    var shipped: Bool
    var allergens: [String]
    var family: Allergen?
    var substitutions: [String]?

    init(id: String, uuid: String, name: String, type: String, slug: String, country: Country, imagePath: String?, shipped: Bool, allergens: [String], family: Allergen?, substitutions: [String]?) {
        self.id = id
        self.uuid = uuid
        self.name = name
        self.type = type
        self.slug = slug
        self.country = country
        self.imagePath = imagePath
        self.shipped = shipped
        self.allergens = allergens
        self.family = family
        self.substitutions = substitutions
    }
}

// MARK: RecipeIngredient convenience initializers and mutators

extension RecipeIngredient {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(RecipeIngredient.self, from: data)
        self.init(id: me.id, uuid: me.uuid, name: me.name, type: me.type, slug: me.slug, country: me.country, imagePath: me.imagePath, shipped: me.shipped, allergens: me.allergens, family: me.family, substitutions: me.substitutions)
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
        id: String? = nil,
        uuid: String? = nil,
        name: String? = nil,
        type: String? = nil,
        slug: String? = nil,
        country: Country? = nil,
        imagePath: String? = nil,
        shipped: Bool? = nil,
        allergens: [String]? = nil,
        family: Allergen? = nil,
        substitutions: [String]? = nil
    ) -> RecipeIngredient {
        return RecipeIngredient(
            id: id ?? self.id,
            uuid: uuid ?? self.uuid,
            name: name ?? self.name,
            type: type ?? self.type,
            slug: slug ?? self.slug,
            country: country ?? self.country,
            imagePath: imagePath ?? self.imagePath,
            shipped: shipped ?? self.shipped,
            allergens: allergens ?? self.allergens,
            family: family ?? self.family,
            substitutions: substitutions ?? self.substitutions
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
