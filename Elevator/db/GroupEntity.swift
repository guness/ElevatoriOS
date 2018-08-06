//
//  GroupEntity.swift
//  Elevator
//
//  Created by Sinan Güneş on 12.05.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import RealmSwift
import Foundation

class GroupEntity: Object {
    @objc dynamic var id: Int64 = 0
    @objc dynamic var uuid: String = ""
    @objc dynamic var address: String? = nil
    @objc dynamic var groupDescription: String? = nil
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    let elevators = List<ElevatorEntity>()
    
    convenience init(group: Group) {
        self.init()
        self.id = group.id
        self.uuid = group.uuid
        self.address = group.address
        self.latitude = group.latitude ?? 0
        self.longitude = group.longitude ?? 0
        self.groupDescription = group.description
        
        for elevator in group.elevators {
            let entity = ElevatorEntity(elevator, group.id)
            self.elevators.append(entity)
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
