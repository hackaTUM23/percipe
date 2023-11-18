//
//  StepImage.swift
//  Percipe
//
//  Created by Leon Friedmann on 18.11.23.
//

import Foundation

class StepImage: Codable {
    var link: String
    var path, caption: String

    init(link: String, path: String, caption: String) {
        self.link = link
        self.path = path
        self.caption = caption
    }
}

// MARK: Image convenience initializers and mutators

extension StepImage {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(StepImage.self, from: data)
        self.init(link: me.link, path: me.path, caption: me.caption)
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
        link: String? = nil,
        path: String? = nil,
        caption: String? = nil
    ) -> StepImage {
        return StepImage(
            link: link ?? self.link,
            path: path ?? self.path,
            caption: caption ?? self.caption
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
