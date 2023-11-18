//
//  YieldIngredient.swift
//  Percipe
//
//  Created by Leon Friedmann on 18.11.23.
//

import Foundation

class YieldIngredient: Codable {
    var id: String
    var amount: Double?
    var unit: String

    init(id: String, amount: Double?, unit: String) {
        self.id = id
        self.amount = amount
        self.unit = unit
    }
}

// MARK: YieldIngredient convenience initializers and mutators

extension YieldIngredient {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(YieldIngredient.self, from: data)
        self.init(id: me.id, amount: me.amount, unit: me.unit)
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
        amount: Double? = nil,
        unit: String? = nil
    ) -> YieldIngredient {
        return YieldIngredient(
            id: id ?? self.id,
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
