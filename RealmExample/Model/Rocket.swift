//
//  Rocket.swift
//  RealmExample
//

import Foundation
import RealmSwift

final class Rocket: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var imageData: Data? = nil

    convenience init(json: JSON.Rocket) {
        self.init()
        id = json.id
        name = json.name
        type = json.type
        title = json.title
    }
}
