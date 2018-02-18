//
//  StopListening.swift
//  Elevator
//
//  Created by Sinan Güneş on 18.02.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation

class StopListening: AbstractMessage {
    let _type = "StopListening"
    let version = 2

    let device: String

    init(device: String) {
        self.device = device
    }
}
