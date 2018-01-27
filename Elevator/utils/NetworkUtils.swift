//
//  NetworkUtils.swift
//  Elevator
//
//  Created by Sinan Güneş on 27.01.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation

struct NetworkUtils {
    static func basicAuth(username: String, password: String?) -> String {
        let loginString = String(format: "%@:%@", username, (password == nil) ? "NULL" : password!)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return "Basic \(base64LoginString)"
    }
}
