//
//  RelayOrder.swift
//  Elevator
//
//  Created by Sinan Güneş on 18.02.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation

class RelayOrder: AbstractMessage {
    let _type = "RelayOrder"
    let version = 2

    let order: Order

    init(order: Order) {
        self.order = order
    }
}
