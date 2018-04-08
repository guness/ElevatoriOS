//
//  RelayOrderResponse.swift
//  Elevator
//
//  Created by Sinan Güneş on 18.02.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation

class RelayOrderResponse: AbstractMessage {
    let _type = "RelayOrderResponse"
    let version = 2

    let order: Order? = nil
    let success: Bool = false
}
