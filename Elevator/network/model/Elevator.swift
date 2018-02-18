//
//  Elevator.swift
//  Elevator
//
//  Created by Sinan Güneş on 18.02.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation

class Elevator: Codable {
    var id: Int64
    var device: String
    var min_floor: Int
    var floor_count: Int
    var address: String?
    var description: String?
    var latitude: Float?
    var longitude: Float?
}
