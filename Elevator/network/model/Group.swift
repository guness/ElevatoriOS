//
//  Group.swift
//  Elevator
//
//  Created by Sinan Güneş on 18.02.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation

class Group: Codable {
    var id: Int64 = 0
    var uuid: String = ""
    var description: String?
    var elevators: [Elevator] = []
}
