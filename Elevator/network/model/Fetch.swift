//
//  Fetch.swift
//  Elevator
//
//  Created by Sinan Güneş on 18.02.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation

class Fetch: Codable {
    var id: Int64?

    /**
    * Group or Uuid
    */
    var type: String
    var uuid: String?

    init(type: String) {
        self.type = type
    }
}
