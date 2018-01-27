//
//  NetworkService.swift
//  Elevator
//
//  Created by Sinan Güneş on 25.01.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import SocketRocket
import Foundation
import FirebaseInstanceID
import os.log

class NetworkService: NSObject, SRWebSocketDelegate {

    static let sharedInstance: NetworkService = {
        let instance = NetworkService()
        // setup code
        return instance
    }()

    var webSocket: SRWebSocket!
    var isConnected = false

    public func connect(token: String?) {
        if webSocket == nil {
            var request = URLRequest(url: URL(string: Constants.HOST)!)
            request.addValue(NetworkUtils.basicAuth(username: "ZAMUNDAAA", password: token), forHTTPHeaderField: "Authorization")
            webSocket = SRWebSocket(urlRequest: request)
            webSocket.delegate = self
            webSocket.open()
        }
    }

    public func webSocketDidOpen(_ webSocket: SRWebSocket) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: webSocketDidOpen", String(describing: type(of: self)))
        }
        isConnected = true;
        let data = "TestString".data(using: .utf8)
        webSocket.sendPing(data)
    }

    // @objc(webSocket:didReceiveMessageWithString:)
    public func webSocket(_ webSocket: SRWebSocket, didReceiveMessageWith string: String) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: didReceiveMessageWith: %@", String(describing: type(of: self)), string)
        }
    }

    public func webSocket(_ webSocket: SRWebSocket, didReceiveMessage message: Any!) {
        if kLog.TracePackets && kLog.Trace {
            if message is NSData {
                os_log("%@: didReceiveMessage: %@", String(describing: type(of: self)), message as! NSData)
            } else if message is NSString {
                os_log("%@: didReceiveMessage: %@", String(describing: type(of: self)), message as! NSString)
            }
        }
    }

    public func webSocket(_ webSocket: SRWebSocket, didFailWithError error: Error) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: didFailWithError: %@", String(describing: error))
        }
    }

    public func webSocket(_ webSocket: SRWebSocket, didCloseWithCode code: NSInteger, reason: String, wasClean clean: Bool) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: didCloseWithCode: %@", String(describing: code))
        }
    }

    public func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: didReceivePong: %@", String(describing: pongPayload))
        }
    }
}

