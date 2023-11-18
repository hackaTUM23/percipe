//
//  Nutrition.swift
//  Percipe
//
//  Created by Leon Friedmann on 18.11.23.
//

import Foundation

class Nutrition: Codable {
    var type, name: String
    var amount: Double
    var unit: String

    init(type: String, name: String, amount: Double, unit: String) {
        self.type = type
        self.name = name
        self.amount = amount
        self.unit = unit
    }
}

// MARK: Nutrition convenience initializers and mutators

extension Nutrition {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Nutrition.self, from: data)
        self.init(type: me.type, name: me.name, amount: me.amount, unit: me.unit)
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
        type: String? = nil,
        name: String? = nil,
        amount: Double? = nil,
        unit: String? = nil
    ) -> Nutrition {
        return Nutrition(
            type: type ?? self.type,
            name: name ?? self.name,
            amount: amount ?? self.amount,
            unit: unit ?? self.unit
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
