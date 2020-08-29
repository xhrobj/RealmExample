//
//  NetworkManager.swift
//  RealmExample
//

import Foundation
import Combine

final class NetworkManager {
    private let session = URLSession.shared
    
    func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        session
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchRockets(from endpoint: Endpoint) -> AnyPublisher<[JSON.Rocket], Never> {
        guard let url = endpoint.absoluteURL else {
            return Just([JSON.Rocket]()).eraseToAnyPublisher()
        }
        return fetch(url: url)
            .replaceError(with: [JSON.Rocket]())
            .eraseToAnyPublisher()
    }
    
    func fetchShips(from endpoint: Endpoint) -> AnyPublisher<[JSON.Ship], Never> {
        guard let url = endpoint.absoluteURL else {
            return Just([JSON.Ship]()).eraseToAnyPublisher()
        }
        return fetch(url: url)
            .replaceError(with: [JSON.Ship]())
            .eraseToAnyPublisher()
    }
}
