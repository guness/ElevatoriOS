//
//  ElevatorRepository.swift
//  Elevator
//
//  Created by Sinan Güneş on 18.02.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation
import RealmSwift

class ElevatorRepository: NSObject {

    static let sharedInstance: ElevatorRepository = {
        let instance = ElevatorRepository()
        // setup code
        return instance
    }()


    public func onGroupInfoArrived(_ info: GroupInfo) {
        let realm = try! Realm()

        info.group?.elevators.forEach({ elevator in
            try! realm.write {
                let entity = ElevatorEntity(elevator: elevator)
                realm.add(entity, update: true)
            }
        })
    }

    public func onRelayOrderResponded(_ response: RelayOrderResponse) {

    }

    public func onStateUpdated(_ state: UpdateState) {

    }
}
