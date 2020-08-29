//
//  Endpoint.swift
//  RealmExample
//

import Foundation

protocol Endpoint {
    var absoluteURL: URL? { get }
}

enum EndpointSpaceX: Endpoint {
    case rocketsV4, shipsV4
    
    private var baseUrl: URL {
        URL(string: "https://api.spacexdata.com")!
    }
    
    var path: String {
        switch self {
        case .rocketsV4:
           return "v4/rockets"
        case .shipsV4:
            return "v4/ships"
        }
    }
    
    var absoluteURL: URL? {
        baseUrl.appendingPathComponent(path)
    }
}
