//
//  ElevatorEntity.swift
//  Elevator
//
//  Created by Sinan Güneş on 18.02.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import RealmSwift
import Foundation

class ElevatorEntity: Object {
    @objc dynamic var id: Int64 = 0
    @objc dynamic var device: String = ""
    @objc dynamic var minFloor: Int = 0
    @objc dynamic var floorCount: Int = 0
    @objc dynamic var address: String? = nil
    @objc dynamic var elvDescription: String? = nil
    @objc dynamic var latitude: Float = 0
    @objc dynamic var longitude: Float = 0

    convenience init(elevator: Elevator) {
        self.init()
        self.id = elevator.id
        self.device = elevator.device
        self.minFloor = elevator.min_floor
        self.floorCount = elevator.floor_count
        self.address = elevator.address
        self.elvDescription = elevator.description
        if let latitude = elevator.latitude {
            self.latitude = latitude
        }
        if let longitude = elevator.longitude {
            self.longitude = longitude
        }
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
