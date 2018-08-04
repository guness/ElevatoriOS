//
//  SettingsEntity.swift
//  Elevator
//
//  Created by Sinan Güneş on 4.08.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import RealmSwift
import Foundation
import RealmSwift

class SettingsEntity: Object {
    @objc dynamic var id: Int64 = 0
    @objc dynamic var key: String = ""
    @objc dynamic var value: String = ""

    convenience init(_ key: String, _ value: String) {
        self.init()
        self.key = key
        self.value = value
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
