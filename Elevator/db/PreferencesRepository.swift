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

    static let sharedInstance: PreferencesRepository = {
        let instance = PreferencesRepository()
        // setup code
        return instance
    }()
}
