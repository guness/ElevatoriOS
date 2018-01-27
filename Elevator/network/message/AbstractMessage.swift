//
// Created by Sinan Güneş on 27.01.2018.
// Copyright (c) 2018 Sinan Güneş. All rights reserved.
//

import Foundation

public protocol AbstractMessage: Codable {
    var _type: String { get }
    var version: Int { get }
}