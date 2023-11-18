//
//  Utensil.swift
//  Percipe
//
//  Created by Leon Friedmann on 18.11.23.
//

import Foundation

class Utensil: Codable {
    var id, name: String
    var type: String?

    init(id: String, type: String?, name: String) {
        self.id = id
        self.type = type
        self.name = name
    }
}

// MARK: Utensil convenience initializers and mutators

extension Utensil {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Utensil.self, from: data)
        self.init(id: me.id, type: me.type, name: me.name)
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
        type: String? = nil,
        name: String? = nil
    ) -> Utensil {
        return Utensil(
            id: id ?? self.id,
            type: type ?? self.type,
            name: name ?? self.name
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
