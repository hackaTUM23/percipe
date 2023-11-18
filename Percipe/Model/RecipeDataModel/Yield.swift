//
//  Yield.swift
//  Percipe
//
//  Created by Leon Friedmann on 18.11.23.
//

import Foundation

class Yield: Codable {
    var yields: Int
    var ingredients: [YieldIngredient]

    init(yields: Int, ingredients: [YieldIngredient]) {
        self.yields = yields
        self.ingredients = ingredients
    }
}

// MARK: Yield convenience initializers and mutators

extension Yield {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Yield.self, from: data)
        self.init(yields: me.yields, ingredients: me.ingredients)
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
        yields: Int? = nil,
        ingredients: [YieldIngredient]? = nil
    ) -> Yield {
        return Yield(
            yields: yields ?? self.yields,
            ingredients: ingredients ?? self.ingredients
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
