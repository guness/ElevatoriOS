//
// Created by Sinan Güneş on 27.01.2018.
// Copyright (c) 2018 Sinan Güneş. All rights reserved.
//

import Foundation

class Echo: AbstractMessage {
    let _type = "Echo"
    let version = 2
    var echo = [String: String]()
}
