//
//  RocketsViewModel.swift
//  RealmExample
//

import Foundation
import Combine
import RealmSwift

final class RocketsViewModel {
    @Published var rockets: [Rocket] = []
    
    private var cancelSet: Set<AnyCancellable> = []
    private var realmObserver: NotificationToken?
    
    init() {
        activateNetworkManager()
        activateRealmObserver()
    }
    
    private func activateNetworkManager() {
        let networkManager = NetworkManager()
        networkManager
            .fetchRockets(from: EndpointSpaceX.rocketsV4)
            .sink(receiveCompletion: { completion in
                guard case .failure(let error) = completion else { return }
                debugPrint(error)
            }, receiveValue: { [weak self] rocketsJson in
                self?.process(rocketsJson: rocketsJson)
            })
            .store(in: &cancelSet)
    }
    
    private func activateRealmObserver() {
        do {
            let realm = try Realm()
            let rockets = realm.objects(Rocket.self)
            realmObserver = rockets.observe { [weak self] _ in
                self?.rockets = Array(rockets)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    private func process(rocketsJson: [JSON.Rocket]) {
        do {
            try importIntoRealm(from: rocketsJson)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    private func importIntoRealm(from rocketsJson: [JSON.Rocket]) throws {
        let realm = try Realm()
        let rockets = realm.objects(Rocket.self)
        realm.beginWrite()
        realm.delete(rockets)
        let newRockets: [Rocket] = try rocketsJson.map{
            let newRocket = Rocket(json: $0)
            if !$0.flickrImages.isEmpty, let imageUrlPath = $0.flickrImages.first,
               let url = URL(string: imageUrlPath) {
                 newRocket.imageData = try Data(contentsOf: url)
            }
            return newRocket
        }
        realm.add(newRockets)
        try realm.commitWrite()
    }
    
    deinit {
        for cancel in cancelSet {
            cancel.cancel()
        }
        realmObserver?.invalidate()
    }
}
