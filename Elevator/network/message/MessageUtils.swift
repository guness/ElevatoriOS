//
// Created by Sinan Güneş on 28.01.2018.
// Copyright (c) 2018 Sinan Güneş. All rights reserved.
//

import Foundation

import os.log

class MessageUtils {
    static let sharedInstance: MessageUtils = {
        let instance = MessageUtils()
        // setup code
        return instance
    }()

    func parseMessage(value: String) -> AbstractMessage? {
        let json = try? JSONSerialization.jsonObject(with: value.data(using: .utf8)!, options: [])

        if let dictionary = json as? [String: Any] {
            if let _type = dictionary["_type"] as? String {
                let decoder = JSONDecoder()
                let data = value.data(using: .utf8)!
                switch _type {
                case String(describing: Echo.self): return try? decoder.decode(Echo.self, from: data)
                case String(describing: GroupInfo.self): return try? decoder.decode(GroupInfo.self, from: data)
                case String(describing: RelayOrderResponse.self): return try? decoder.decode(RelayOrderResponse.self, from: data)
                case String(describing: UpdateState.self): return try? decoder.decode(UpdateState.self, from: data)
                default:
                    os_log("%@: Type Unregistered: %@", String(describing: type(of: self)), _type)
                }
            }
        }
        return nil
    }
}
