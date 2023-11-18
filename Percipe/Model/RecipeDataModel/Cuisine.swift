//
//  Cuisine.swift
//  Percipe
//
//  Created by Leon Friedmann on 18.11.23.
//

import Foundation

class Cuisine: Codable {
    var id, type, name, slug: String
    var iconLink: String

    init(id: String, type: String, name: String, slug: String, iconLink: String) {
        self.id = id
        self.type = type
        self.name = name
        self.slug = slug
        self.iconLink = iconLink
    }
}

// MARK: Cuisine convenience initializers and mutators

extension Cuisine {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Cuisine.self, from: data)
        self.init(id: me.id, type: me.type, name: me.name, slug: me.slug, iconLink: me.iconLink)
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
        name: String? = nil,
        slug: String? = nil,
        iconLink: String? = nil
    ) -> Cuisine {
        return Cuisine(
            id: id ?? self.id,
            type: type ?? self.type,
            name: name ?? self.name,
            slug: slug ?? self.slug,
            iconLink: iconLink ?? self.iconLink
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
