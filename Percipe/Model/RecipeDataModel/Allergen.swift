//
//  Allergen.swift
//  Percipe
//
//  Created by Leon Friedmann on 18.11.23.
//

import Foundation

class Allergen: Codable {
    var id, name, type, slug: String
    var iconLink: String?
    var iconPath: String?
    var triggersTracesOf, tracesOf: Bool?
    var uuid: String?
    var priority: Int?

    init(id: String, name: String, type: String, slug: String, iconLink: String?, iconPath: String?, triggersTracesOf: Bool?, tracesOf: Bool?, uuid: String?, priority: Int?) {
        self.id = id
        self.name = name
        self.type = type
        self.slug = slug
        self.iconLink = iconLink
        self.iconPath = iconPath
        self.triggersTracesOf = triggersTracesOf
        self.tracesOf = tracesOf
        self.uuid = uuid
        self.priority = priority
    }
}

// MARK: Allergen convenience initializers and mutators

extension Allergen {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Allergen.self, from: data)
        self.init(id: me.id, name: me.name, type: me.type, slug: me.slug, iconLink: me.iconLink, iconPath: me.iconPath, triggersTracesOf: me.triggersTracesOf, tracesOf: me.tracesOf, uuid: me.uuid, priority: me.priority)
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
        name: String? = nil,
        type: String? = nil,
        slug: String? = nil,
        iconLink: String?? = nil,
        iconPath: String?? = nil,
        triggersTracesOf: Bool?? = nil,
        tracesOf: Bool?? = nil,
        uuid: String?? = nil,
        priority: Int?? = nil
    ) -> Allergen {
        return Allergen(
            id: id ?? self.id,
            name: name ?? self.name,
            type: type ?? self.type,
            slug: slug ?? self.slug,
            iconLink: iconLink ?? self.iconLink,
            iconPath: iconPath ?? self.iconPath,
            triggersTracesOf: triggersTracesOf ?? self.triggersTracesOf,
            tracesOf: tracesOf ?? self.tracesOf,
            uuid: uuid ?? self.uuid,
            priority: priority ?? self.priority
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum Country: String, Codable {
    case de = "DE"
}
