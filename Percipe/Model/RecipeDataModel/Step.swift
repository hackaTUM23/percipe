//
//  Step.swift
//  Percipe
//
//  Created by Leon Friedmann on 18.11.23.
//

import Foundation

class Step: Codable {
    var index: Int
    var instructions, instructionsHTML, instructionsMarkdown: String
    var ingredients, utensils: [String]
    var timers: [JSONAny]
    var images: [StepImage]
    var videos: [JSONAny]

    init(index: Int, instructions: String, instructionsHTML: String, instructionsMarkdown: String, ingredients: [String], utensils: [String], timers: [JSONAny], images: [StepImage], videos: [JSONAny]) {
        self.index = index
        self.instructions = instructions
        self.instructionsHTML = instructionsHTML
        self.instructionsMarkdown = instructionsMarkdown
        self.ingredients = ingredients
        self.utensils = utensils
        self.timers = timers
        self.images = images
        self.videos = videos
    }
}

// MARK: Step convenience initializers and mutators

extension Step {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Step.self, from: data)
        self.init(index: me.index, instructions: me.instructions, instructionsHTML: me.instructionsHTML, instructionsMarkdown: me.instructionsMarkdown, ingredients: me.ingredients, utensils: me.utensils, timers: me.timers, images: me.images, videos: me.videos)
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
        index: Int? = nil,
        instructions: String? = nil,
        instructionsHTML: String? = nil,
        instructionsMarkdown: String? = nil,
        ingredients: [String]? = nil,
        utensils: [String]? = nil,
        timers: [JSONAny]? = nil,
        images: [StepImage]? = nil,
        videos: [JSONAny]? = nil
    ) -> Step {
        return Step(
            index: index ?? self.index,
            instructions: instructions ?? self.instructions,
            instructionsHTML: instructionsHTML ?? self.instructionsHTML,
            instructionsMarkdown: instructionsMarkdown ?? self.instructionsMarkdown,
            ingredients: ingredients ?? self.ingredients,
            utensils: utensils ?? self.utensils,
            timers: timers ?? self.timers,
            images: images ?? self.images,
            videos: videos ?? self.videos
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
