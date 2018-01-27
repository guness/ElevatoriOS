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

    private var webSocket: SRWebSocket!
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

    public func sendMessage<T>(message: T) where T: AbstractMessage {
        let json = try! String(data: JSONEncoder().encode(message), encoding: .utf8)!

        if kLog.TracePackets && kLog.Trace {
            os_log("%@: sendMessage %@", String(describing: type(of: self)), json)
        }
        webSocket.send(json)
    }

    func webSocketDidOpen(_ webSocket: SRWebSocket) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: webSocketDidOpen", String(describing: type(of: self)))
        }
        isConnected = true;
        let data = "TestString".data(using: .utf8)
        webSocket.sendPing(data)
    }

    func webSocket(_ webSocket: SRWebSocket, didReceiveMessageWith string: String) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: didReceiveMessageWith: %@", String(describing: type(of: self)), string)
        }
    }

    func webSocket(_ webSocket: SRWebSocket, didReceiveMessage message: Any!) {
        if kLog.TracePackets && kLog.Trace {
            if message is Data {
                os_log("%@: didReceiveMessage binary length: %@", String(describing: type(of: self)), (message as! Data).count)
            } else if message is String {
                os_log("%@: didReceiveMessage: %@", String(describing: type(of: self)), message as! String)
            }
        }
    }

    func webSocket(_ webSocket: SRWebSocket, didFailWithError error: Error) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: didFailWithError: %@", String(describing: error))
        }
    }

    func webSocket(_ webSocket: SRWebSocket, didCloseWithCode code: Int, reason: String, wasClean clean: Bool) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: didCloseWithCode: %@", String(describing: code))
        }
    }

    func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: didReceivePong: %@", String(describing: pongPayload))
        }
    }
}

