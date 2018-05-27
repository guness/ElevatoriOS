//
//  ElevatorRepository.swift
//  Elevator
//
//  Created by Sinan Güneş on 18.02.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class ElevatorRepository: NSObject {

    private let groupInfoObservable: PublishSubject<GroupInfo> = PublishSubject.init()
    private let stateObservable: PublishSubject<ElevatorState> = PublishSubject.init()
    private let orderResponseObservable: PublishSubject<RelayOrderResponse> = PublishSubject.init()

    static let sharedInstance: ElevatorRepository = {
        let instance = ElevatorRepository()
        // setup code
        return instance
    }()

    public func onGroupInfoArrived(_ info: GroupInfo) {
        let realm = try! Realm()

        if let group = info.group {
            try! realm.write {
                if let realmGroup = realm.objects(GroupEntity.self).filter("uuid = %@", group.uuid).first{
                    realm.delete(realmGroup.elevators)
                }
                
                let entity = GroupEntity(group: group)
                realm.add(entity, update: true)
            }
        }
        
        groupInfoObservable.onNext(info)
    }

    public func onRelayOrderResponded(_ response: RelayOrderResponse) {
        orderResponseObservable.onNext(response)
    }

    public func onStateUpdated(_ updateState: UpdateState) {
        if let state = updateState.state {
            stateObservable.onNext(state)
        }
    }

    public func getGroupInfoObservable() -> Observable<GroupInfo> {
        return groupInfoObservable
    }

    public func getStateObservable() -> Observable<ElevatorState> {
        return stateObservable
    }

    public func getOrderResponseObservable() -> Observable<RelayOrderResponse> {
        return orderResponseObservable
    }
}
