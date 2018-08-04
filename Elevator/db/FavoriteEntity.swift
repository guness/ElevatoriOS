//
//  FavoriteEntity.swift
//  Elevator
//
//  Created by Sinan Güneş on 4.08.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import RealmSwift
import Foundation

class FavoriteEntity: Object {
    @objc dynamic var key: String = ""
    @objc dynamic var value: String = ""
    /**
     * TypeDef
     */
    @objc dynamic var type: String = ""
    @objc dynamic var groupId: Int64 = 0
    @objc dynamic var device: String = ""
    @objc dynamic var floor: Int = 0
    @objc dynamic var favDescription: String? = nil
    
    override static func primaryKey() -> String? {
        return "key"
    }
}

