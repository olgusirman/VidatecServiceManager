//
//  Room.swift
//
//
//  Created by Olgu SIRMAN on 09/01/2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let room = try Room(json)

import Foundation

// MARK: - Room
public struct Room: Codable, Identifiable {
    public var id, createdAt, name: String?
    public var isOccupied: Bool?
}

// MARK: Room convenience initializers and mutators

public extension Room {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Room.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: String?? = nil,
        createdAt: String?? = nil,
        name: String?? = nil,
        isOccupied: Bool?? = nil
    ) -> Room {
        return Room(
            id: id ?? self.id,
            createdAt: createdAt ?? self.createdAt,
            name: name ?? self.name,
            isOccupied: isOccupied ?? self.isOccupied
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// JSONSchemaSupport.swift

public typealias Rooms = [Room]

public extension Array where Element == Rooms.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Rooms.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public extension Room {
    
    static private let mockRoom1 = Room(id: "1", createdAt: "2019-04-29T03:44:45.496Z", name: "pixel", isOccupied: false)
    static private let mockRoom2 = Room(id: "2", createdAt: "2019-04-29T16:00:04.266Z", name: "port", isOccupied: true)
    
    static var mockRooms = [mockRoom1, mockRoom2]
    
}
