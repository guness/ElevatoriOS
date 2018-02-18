//
//  FetchInfo.swift
//  Elevator
//
//  Created by Sinan Güneş on 18.02.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation

class FetchInfo: AbstractMessage {
    let _type = "FetchInfo"
    let version = 2

    let fetch: Fetch

    init(fetch: Fetch) {
        self.fetch = fetch
    }
}
