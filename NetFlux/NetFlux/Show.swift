//
//  Show.swift
//  NetFlux
//
//  Created by Shahin on 2019-02-02.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import Foundation
import CoreData

class Show: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case language
        case summary
        case image
        case externals
        case isFavourited
    }
    
    enum ImageKeys: String, CodingKey {
        case medium
        case original
    }
    
    enum ExternalKeys: String, CodingKey {
        case tvrage
        case thetvdb
        case imdb
    }
    
    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var type: String
    @NSManaged var language: String
    @NSManaged var summary: String
    @NSManaged var medium: String
    @NSManaged var original: String
    @NSManaged var isFavourited: Bool
    @NSManaged var tvrage: Int64
    @NSManaged var thetvdb: Int64
    @NSManaged var imdb: String
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: Constants.Persistence.EntityNames.show, in: managedObjectContext) else {
                fatalError("Failed to decode Show")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int64.self, forKey: .id) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Unavailable"
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? "Unknown"
        self.language = try container.decodeIfPresent(String.self, forKey: .language) ?? "Unknown"
        self.summary = try container.decodeIfPresent(String.self, forKey: .summary) ?? "None"
        self.isFavourited = try container.decodeIfPresent(Bool.self, forKey: .isFavourited) ?? false
        
        let imageContainer = try container.nestedContainer(keyedBy: ImageKeys.self, forKey: .image)
        self.medium = try imageContainer.decode(String.self, forKey: .medium)
        self.original = try imageContainer.decode(String.self, forKey: .original)

        let externalsContainer = try container.nestedContainer(keyedBy: ExternalKeys.self, forKey: .externals)
        self.tvrage = try externalsContainer.decode(Int64.self, forKey: .tvrage)
        self.thetvdb = try externalsContainer.decode(Int64.self, forKey: .thetvdb)
        self.imdb = try externalsContainer.decode(String.self, forKey: .imdb)
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(language, forKey: .language)
        try container.encode(summary, forKey: .summary)
        try container.encode(isFavourited, forKey: .isFavourited)
        
        var imageContainer = container.nestedContainer(keyedBy: ImageKeys.self, forKey: .image)
        try imageContainer.encode(medium, forKey: .medium)
        try imageContainer.encode(original, forKey: .original)
        
        var externalsContainer = container.nestedContainer(keyedBy: ExternalKeys.self, forKey: .externals)
        try externalsContainer.encode(tvrage, forKey: .tvrage)
        try externalsContainer.encode(thetvdb, forKey: .thetvdb)
        try externalsContainer.encode(imdb, forKey: .imdb)
    }
}

public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
