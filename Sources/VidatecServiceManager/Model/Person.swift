//
//  Person.swift
//  
//
//  Created by Olgu SIRMAN on 09/01/2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let person = try Person(json)

import Foundation
import UIKit

// MARK: - Person
public struct Person: Codable, Identifiable {
    public var id, createdAt: String?
    public var avatar: String?
    public var jobTitle, phone, favouriteColor, email: String?
    public var firstName, lastName: String?
    
    public var name: String {
        "\(firstName ?? "")  \(lastName ?? "")"
    }
    
    public var isEmailValid: Bool {
        if let url = URL(string: "mailto:\(email ?? "")"), UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }
    
    public var validatedEmail: URL? {
        if isEmailValid {
            return URL(string: "mailto:\(email ?? "")")!
        }
        return nil
    }
}

// MARK: Person convenience initializers and mutators

public extension Person {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Person.self, from: data)
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
        avatar: String?? = nil,
        jobTitle: String?? = nil,
        phone: String?? = nil,
        favouriteColor: String?? = nil,
        email: String?? = nil,
        firstName: String?? = nil,
        lastName: String?? = nil
    ) -> Person {
        return Person(
            id: id ?? self.id,
            createdAt: createdAt ?? self.createdAt,
            avatar: avatar ?? self.avatar,
            jobTitle: jobTitle ?? self.jobTitle,
            phone: phone ?? self.phone,
            favouriteColor: favouriteColor ?? self.favouriteColor,
            email: email ?? self.email,
            firstName: firstName ?? self.firstName,
            lastName: lastName ?? self.lastName
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

public typealias People = [Person]

public extension Array where Element == People.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(People.self, from: data)
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

extension Person: Equatable, Hashable {
    public static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public extension Person {
    
    static private let mockPerson1 = Person(id: "1",
                                            createdAt: "2019-04-29T10:04:24.713Z",
                                            avatar: "https://s3.amazonaws.com/uifaces/faces/twitter/johndezember/128.jpg",
                                            jobTitle: "Dynamic Implementation Designer",
                                            phone: "556.662.4422 x3344",
                                            favouriteColor: "#023a77",
                                            email: "Benny78@gmail.com",
                                            firstName: "Jan",
                                            lastName: "Thompson")
    
    static private let mockPerson2 = Person(id: "2",
                                            createdAt: "2019-04-28T21:05:15.710Z",
                                            avatar: "https://s3.amazonaws.com/uifaces/faces/twitter/lingeswaran/128.jpg",
                                            jobTitle: "Lead Response Coordinator",
                                            phone: "626-316-8058 x077",
                                            favouriteColor: "#39653b",
                                            email: "Jordon.Parker30@hotmail.com",
                                            firstName: "Rhett",
                                            lastName: "Carter")
    
    static var mockPeople = [mockPerson1,mockPerson2]
    
}
