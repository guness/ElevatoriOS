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

    public func connect(_ token: String?) {
        if webSocket == nil {
            var request = URLRequest(url: URL(string: Constants.HOST)!)

            var username: String
            if let identifierForVendor = UIDevice.current.identifierForVendor {
                username = identifierForVendor.uuidString
            } else {
                username = UUID().uuidString
                os_log("%@: connect using generated UUID %@", String(describing: type(of: self)), username)
            }
            request.addValue(NetworkUtils.basicAuth(username: username, password: token), forHTTPHeaderField: "Authorization")
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

    func webSocketDidOpen(_ ws: SRWebSocket) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: webSocketDidOpen", String(describing: type(of: self)))
        }
        isConnected = true;
        let data = "TestString".data(using: .utf8)
        ws.sendPing(data)

        let fetch = Fetch(type: Fetch.TYPE_GROUP)
        fetch.id = 1
        sendMessage(message: FetchInfo(fetch: fetch))
    }

    func webSocket(_ ws: SRWebSocket, didReceiveMessageWith string: String) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: didReceiveMessageWith: %@", String(describing: type(of: self)), string)
        }
        let json = try! JSONSerialization.jsonObject(with: string.data(using: .utf8)!, options: [])

        if let dictionary = json as? [String: Any] {
            if let value = dictionary["_type"] as? String {
                let decoder = JSONDecoder()
                let data = string.data(using: .utf8)!
                switch value {
                case String(describing: Echo.self):
                    // We can ignore echo messages since it it already printed
                    break
                case String(describing: GroupInfo.self):
                    let info: GroupInfo = try! decoder.decode(GroupInfo.self, from: data)
                    ElevatorRepository.sharedInstance.onGroupInfoArrived(info)
                    break
                case String(describing: RelayOrderResponse.self):
                    let response: RelayOrderResponse = try! decoder.decode(RelayOrderResponse.self, from: data)
                    ElevatorRepository.sharedInstance.onRelayOrderResponded(response)
                    break
                case String(describing: UpdateState.self):
                    let state: UpdateState = try! decoder.decode(UpdateState.self, from: data)
                    ElevatorRepository.sharedInstance.onStateUpdated(state)
                    break
                default:
                    os_log("%@: Type Unregistered: %@", String(describing: type(of: self)), value)
                        //TODO: Throw something or not
                }
            }
        }
    }

    func webSocket(_ ws: SRWebSocket, didReceiveMessage message: Any!) {
        if kLog.TracePackets && kLog.Trace {
            if let string = message as? String {
                webSocket(ws, didReceiveMessageWith: string)
            } else if let data = message as? Data {
                os_log("%@: didReceiveMessage binary length: %@", String(describing: type(of: self)), data.count)
            } else {
                os_log("%@: didReceiveMessage UNKNOWN: %@", String(describing: type(of: self)), String(describing: message))
                //TODO: Throw something or not
            }
        }
    }

    func webSocket(_ ws: SRWebSocket, didFailWithError error: Error) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: didFailWithError: %@", String(describing: error))
        }
    }

    func webSocket(_ ws: SRWebSocket, didCloseWithCode code: Int, reason: String, wasClean clean: Bool) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: didCloseWithCode: %@", String(describing: code))
        }
    }

    func webSocket(_ ws: SRWebSocket!, didReceivePong pongPayload: Data!) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: didReceivePong: %@", String(describing: pongPayload))
        }
    }

    func fetchUUID(_ uuid: String) {
        let fetch = Fetch(type: Fetch.TYPE_UUID)
        fetch.uuid = uuid
        sendMessage(message: FetchInfo(fetch: fetch))
    }
}

