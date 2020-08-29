//
//  Rocket.swift
//  RealmExample
//

import Foundation
import RealmSwift

final class Ship: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var homePort: String = ""
    @objc dynamic var imageData: Data? = nil

    convenience init(json: JSON.Ship) {
        self.init()
        id = json.id
        name = json.name
        homePort = json.homePort
    }
}
