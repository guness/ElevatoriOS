//
//  Constants.swift
//  Elevator
//
//  Created by Sinan Güneş on 22.01.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation

struct kLog {
    
    #if DEBUG
    static let Trace = true
    #else
    static let Trace = true
    #endif
    
    static let TraceViews = true
    static let TracePackets = true
    static let TraceApplication = true
}

struct Constants {
    static let HOST = "ws://elevator.onintech.com/mobile"
}
