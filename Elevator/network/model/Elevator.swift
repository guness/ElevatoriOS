//
//  Elevator.swift
//  Elevator
//
//  Created by Sinan Güneş on 18.02.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation

class Elevator: Codable {
    var id: Int64 = 0
    var device: String = ""
    var min_floor: Int = 0
    var floor_count: Int = 0
    var address: String?
    var description: String?
    var latitude: Float?
    var longitude: Float?
}
