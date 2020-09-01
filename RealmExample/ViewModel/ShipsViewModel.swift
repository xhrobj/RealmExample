//
//  RocketsViewModel.swift
//  RealmExample
//

import Foundation
import Combine
import RealmSwift

final class ShipsViewModel {
    @Published var ships: [Ship] = []
    
    private var cancelSet: Set<AnyCancellable> = []
    private var realmObserver: NotificationToken?
    
    init() {
        activateNetworkManager()
        activateRealmObserver()
    }
    
    private func activateNetworkManager() {
        let networkManager = NetworkManager()
        networkManager
            .fetchShips(from: EndpointSpaceX.shipsV4)
            .sink {[weak self] shipsJson in
                self?.process(shipsJson: shipsJson)
        }
        .store(in: &cancelSet)
    }
    
    private func activateRealmObserver() {
        do {
            let realm = try Realm()
            let ships = realm.objects(Ship.self)
            realmObserver = ships.observe { [weak self] _ in
                self?.ships = Array(ships)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    private func process(shipsJson: [JSON.Ship]) {
        do {
            try importIntoRealm(from: shipsJson)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    private func importIntoRealm(from shipsJson: [JSON.Ship]) throws {
        let realm = try Realm()
        let ships = realm.objects(Ship.self)
        realm.beginWrite()
        realm.delete(ships)
        let newShips: [Ship] = try shipsJson.map{
            let newShip = Ship(json: $0)
            if let imageUrlPath = $0.image, let url = URL(string: imageUrlPath) {
                 newShip.imageData = try Data(contentsOf: url)
            }
            return newShip
        }
        realm.add(newShips)
        try realm.commitWrite()
    }
    
    deinit {
        for cancel in cancelSet {
            cancel.cancel()
        }
        realmObserver?.invalidate()
    }
}
