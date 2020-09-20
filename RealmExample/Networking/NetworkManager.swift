//
//  NetworkManager.swift
//  RealmExample
//

import Foundation
import Combine

enum EndpointError: Error {
    case wrongURL
}

final class NetworkManager {
    private let session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        return URLSession(configuration: config)
    }()
    
    func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        session
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchRockets(from endpoint: Endpoint) -> AnyPublisher<[JSON.Rocket], Error> {
        guard let url = endpoint.absoluteURL else {
            return Fail(error: EndpointError.wrongURL).eraseToAnyPublisher()
        }
        return fetch(url: url)
            .mapError{ $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func fetchShips(from endpoint: Endpoint) -> AnyPublisher<[JSON.Ship], Error> {
        guard let url = endpoint.absoluteURL else {
            return Fail(error: EndpointError.wrongURL).eraseToAnyPublisher()
        }
        return fetch(url: url)
            .mapError{ $0 as Error }
            .eraseToAnyPublisher()
    }
}
