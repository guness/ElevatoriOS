//
//  NetworkService.swift
//  Elevator
//
//  Created by Sinan Güneş on 25.01.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import SocketRocket
import Foundation
import RealmSwift
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
            let username = PreferencesRepository.sharedInstance.getUUID()
            os_log("%@: connect using generated UUID %@", String(describing: type(of: self)), username)
            request.addValue(NetworkUtils.basicAuth(username: username, password: token), forHTTPHeaderField: "Authorization")
            webSocket = SRWebSocket(urlRequest: request)
            webSocket.delegate = self
            webSocket.open()
        }
    }
    
    private func sendMessage<T>(message: T) -> Bool where T: AbstractMessage {
        let json = try! String(data:JSONEncoder().encode(message), encoding: .utf8)!

        if kLog.TracePackets && kLog.Trace {
            os_log("%@: sendMessage %@", String(describing: type(of: self)), json)
        }
        let error = tryBlock {
            self.webSocket.send(json)
        }
        
        return error == nil
    }

    func webSocketDidOpen(_ ws: SRWebSocket) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: webSocketDidOpen", String(describing: type(of: self)))
        }
        isConnected = true;
        let data = "TestString".data(using: .utf8)
        ws.sendPing(data)

        let realm = try! Realm()

        let groups = realm.objects(GroupEntity.self)
        if (groups.count == 0) {
            _ = fetchUUID(Constants.DEMO_GROUP_UUID)
        } else {
            for group in groups {
                _ = fetchUUID(group.uuid)
            }
        }
    }

    func webSocket(_ ws: SRWebSocket, didReceiveMessageWith string: String) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: didReceiveMessageWith: %@", String(describing: type(of: self)), string)
        }

        if let message = MessageUtils.sharedInstance.parseMessage(value: string) {
            if message is Echo {
                // We can ignore echo messages since it it already printed
            } else if message is GroupInfo {
                ElevatorRepository.sharedInstance.onGroupInfoArrived(message as! GroupInfo)
            } else if message is RelayOrderResponse {
                ElevatorRepository.sharedInstance.onRelayOrderResponded(message as! RelayOrderResponse)
            } else if message is UpdateState {
                ElevatorRepository.sharedInstance.onStateUpdated(message as! UpdateState)
            } else {
                os_log("%@: Unhandled message: %@", String(describing: type(of: self)), message._type)
                //TODO: Throw something or not
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
        webSocket.close()
        webSocket = nil
    }

    func webSocket(_ ws: SRWebSocket, didCloseWithCode code: Int, reason: String, wasClean clean: Bool) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: didCloseWithCode: %@", String(describing: code))
        }
        webSocket.close()
        webSocket = nil
    }

    func webSocket(_ ws: SRWebSocket!, didReceivePong pongPayload: Data!) {
        if kLog.TracePackets && kLog.Trace {
            os_log("%@: didReceivePong: %@", String(describing: pongPayload))
        }
    }

    func fetchUUID(_ uuid: String)  -> Bool {
        let fetch = Fetch(type: Fetch.TYPE_UUID)
        fetch.uuid = uuid
        return sendMessage(message: FetchInfo(fetch: fetch))
    }

    func sendRelayOrder(device: String, floor: Int) -> Bool {
        let order = Order()
        order.floor = floor
        order.device = device
        return sendMessage(message: RelayOrder(order: order))
    }

    func sendListenDevice(device: String) -> Bool {
        return sendMessage(message: ListenDevice(device: device))
    }

    func sendStopListenDevice(device: String) -> Bool {
        return sendMessage(message: StopListening(device: device))
    }
}

