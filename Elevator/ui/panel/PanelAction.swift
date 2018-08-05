//
//  PanelAction.swift
//  Elevator
//
//  Created by Sinan Güneş on 5.08.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation

class PanelAction {
    var device: String
    var floor: Int?

    init(device: String, floor: Int? = nil) {
        self.device = device
        self.floor = floor
    }
}
