//
//  PreferencesRepository.swift
//  Elevator
//
//  Created by Sinan Güneş on 5.08.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class PreferencesRepository: NSObject {

    func getUUID() -> String {
        if let identifierForVendor = UIDevice.current.identifierForVendor {
            return identifierForVendor.uuidString
        } else {
            let realm = try! Realm()
            var entity = realm.objects(SettingsEntity.self).filter("key = %@", SettingDef.UUID).first
            if entity == nil {
                let uuid = UUID().uuidString
                entity = SettingsEntity(SettingDef.UUID, uuid)
                try! realm.write {
                    realm.add(entity!, update: true)
                }
            }

            return entity!.value
        }
    }

    func insert(favorite: FavoriteEntity) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(favorite, update: true)
        }
    }

    func insert(entity: PanelPrefsEntity) {
        let realm = try! Realm()
        try! realm.write {
            if let current = realm.objects(PanelPrefsEntity.self).filter("key = %@ AND device = %@", entity.key, entity.device).first {
                realm.delete(current)
            }
            realm.add(entity, update: true)
        }
    }
    
    func delete(entity: PanelPrefsEntity) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(entity)
        }
    }

    func insertOrder(device: String, floor: Int) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(OrderEntity(device, floor), update: true)
        }
    }

    func clearOrder() {
        let realm = try! Realm()
        let order = realm.objects(OrderEntity.self)
        try! realm.write {
            realm.delete(order)
        }
    }

    func getOrder() -> OrderEntity? {
        let realm = try! Realm()
        return realm.objects(OrderEntity.self).first
    }

    static let sharedInstance: PreferencesRepository = {
        let instance = PreferencesRepository()
        // setup code
        return instance
    }()
}
