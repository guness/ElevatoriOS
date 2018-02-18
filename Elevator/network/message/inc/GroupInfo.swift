//
//  GroupInfo.swift
//  Elevator
//
//  Created by Sinan Güneş on 18.02.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation

class GroupInfo: AbstractMessage {
    let _type = "GroupInfo"
    let version = 2

    let group: Group?
}
