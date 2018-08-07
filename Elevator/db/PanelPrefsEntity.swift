//
//  PanelPrefsEntity.swift
//  Elevator
//
//  Created by Sinan Güneş on 5.08.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import RealmSwift
import Foundation

class PanelPrefsEntity: Object {
    @objc dynamic var id: String = NSUUID().uuidString
    /**
    * KeyDef
    */
    @objc dynamic var key: String = ""
    @objc dynamic var groupId: Int64 = 0
    @objc dynamic var device: String = ""
    @objc dynamic var floor: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
