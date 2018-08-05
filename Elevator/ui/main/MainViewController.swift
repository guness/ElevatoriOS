//
//  MainViewController.swift
//  Elevator
//
//  Created by Sinan Güneş on 22.01.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import RxSwift
import RealmSwift
import UIKit

class MainViewController: SGViewController {

    var favorites: Results<FavoriteEntity>? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let realm = try! Realm()
        favorites = realm.objects(FavoriteEntity.self)
    }


    @IBAction func onL1Clicked(_ sender: Any) {
        onFavoriteClicked(KeyDef.L1)
    }

    @IBAction func onL2Clicked(_ sender: Any) {
        onFavoriteClicked(KeyDef.L2)
    }

    @IBAction func onL3Clicked(_ sender: Any) {
        onFavoriteClicked(KeyDef.L3)
    }

    @IBAction func onL4Clicked(_ sender: Any) {
        onFavoriteClicked(KeyDef.L4)
    }

    @IBAction func onR1Clicked(_ sender: Any) {
        onFavoriteClicked(KeyDef.R1)
        //TODO: toPanel()
    }

    @IBAction func onR2Clicked(_ sender: Any) {
        onFavoriteClicked(KeyDef.R2)
        //TODO: toGroupPicker(action: GroupAction.Pick)
    }

    @IBAction func onR3Clicked(_ sender: Any) {
        onFavoriteClicked(KeyDef.R3)
        //TODO: toElevatorPicker(action: ElevatorAction.Pick)
    }

    @IBAction func onR4Clicked(_ sender: Any) {
        onFavoriteClicked(KeyDef.R4)
    }

    func onFavoriteClicked(_ key: String) {
        let type = try! getType(key: key)

        if let favorite = favorites?.filter("key = %@", key).first {
            if type == TypeDef.TYPE_FLOOR {
                toPanel(action: PanelAction(device: favorite.device, floor: favorite.floor))
            } else if type == TypeDef.TYPE_ELEVATOR {
                toPanel(action: PanelAction(device: favorite.device))
            }
        } else {
            if type == TypeDef.TYPE_FLOOR {
                toElevatorPicker(action: ElevatorAction.PickFloor)
            } else if type == TypeDef.TYPE_ELEVATOR {
                toElevatorPicker(action: ElevatorAction.PickElevator)
            }
        }
    }

    func getType(key: String) throws -> String? {
        switch (key) {
        case KeyDef.L1, KeyDef.L2, KeyDef.L3, KeyDef.L4:
            return TypeDef.TYPE_ELEVATOR
        case KeyDef.R1, KeyDef.R2, KeyDef.R3, KeyDef.R4:
            return TypeDef.TYPE_FLOOR
        default: return nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
