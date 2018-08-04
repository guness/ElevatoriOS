//
//  OrderEntity.swift
//  Elevator
//
//  Created by Sinan Güneş on 5.08.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import RealmSwift
import Foundation

class OrderEntity: Object {
    @objc dynamic var id: Int64 = 1
    @objc dynamic var device: String = ""
    @objc dynamic var floor: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}