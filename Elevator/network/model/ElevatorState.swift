//
//  ElevatorState.swift
//  Elevator
//
//  Created by Sinan Güneş on 18.02.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation

class ElevatorState: Codable {
    var device: String
    var online: Bool
    var floor: Int
    var busy: Bool

    /**
    * UP or DOWN
    */
    var direction: String?

    /**
     * PASS or STOP
     */
    var action: String?


}
