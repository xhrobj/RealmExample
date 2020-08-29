//
//  Rocket.swift
//  RealmExample
//

import Foundation

struct JSON {}

extension JSON {
    struct Rocket: Codable {
        let id: String
        let name: String
        let type: String
        let title: String
        let flickrImages: [String]
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case type
            case title = "description"
            case flickrImages = "flickr_images"
        }
    }
    
    struct Ship: Codable {
        let id: String
        let name: String
        let homePort: String
        let image: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case homePort = "home_port"
            case image
        }
    }
}
