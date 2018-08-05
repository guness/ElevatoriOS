//
//  UpdateState.swift
//  Elevator
//
//  Created by Sinan Güneş on 18.02.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation

class UpdateState: AbstractMessage {
    let _type = "UpdateState"
    let version = 2

    var state: ElevatorState? = nil
}
