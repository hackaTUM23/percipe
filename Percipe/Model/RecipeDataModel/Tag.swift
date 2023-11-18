//
//  Tag.swift
//  Percipe
//
//  Created by Leon Friedmann on 18.11.23.
//

import Foundation

class Tag: Codable {
    var id, type, name, slug: String
    var colorHandle: String
    var preferences: [String]
    var displayLabel: Bool

    init(id: String, type: String, name: String, slug: String, colorHandle: String, preferences: [String], displayLabel: Bool) {
        self.id = id
        self.type = type
        self.name = name
        self.slug = slug
        self.colorHandle = colorHandle
        self.preferences = preferences
        self.displayLabel = displayLabel
    }
}

// MARK: Tag convenience initializers and mutators

extension Tag {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Tag.self, from: data)
        self.init(id: me.id, type: me.type, name: me.name, slug: me.slug, colorHandle: me.colorHandle, preferences: me.preferences, displayLabel: me.displayLabel)
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
        colorHandle: String? = nil,
        preferences: [String]? = nil,
        displayLabel: Bool? = nil
    ) -> Tag {
        return Tag(
            id: id ?? self.id,
            type: type ?? self.type,
            name: name ?? self.name,
            slug: slug ?? self.slug,
            colorHandle: colorHandle ?? self.colorHandle,
            preferences: preferences ?? self.preferences,
            displayLabel: displayLabel ?? self.displayLabel
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
