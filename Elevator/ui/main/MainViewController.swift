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

    var notificationToken: NotificationToken? = nil
    var favorites: Results<FavoriteEntity>? = nil
    var buttonClicked: String? = nil

    @IBOutlet weak var l1label: UILabel!
    @IBOutlet weak var l2label: UILabel!
    @IBOutlet weak var l3label: UILabel!
    @IBOutlet weak var l4label: UILabel!
    @IBOutlet weak var r1label: UILabel!
    @IBOutlet weak var r2label: UILabel!
    @IBOutlet weak var r3label: UILabel!
    @IBOutlet weak var r4label: UILabel!
    @IBOutlet weak var r1button: UIButton!
    @IBOutlet weak var r2button: UIButton!
    @IBOutlet weak var r3button: UIButton!
    @IBOutlet weak var r4button: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let realm = try! Realm()
        favorites = realm.objects(FavoriteEntity.self)

        // Observe Results Notifications
        notificationToken = favorites?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self?.reloadButtonLabels()
            case .update(_, _, _, _):
                // Query results have changed, so apply them to the UITableView
                self?.reloadButtonLabels()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }

    func reloadButtonLabels() {
        l1label.text = "New Elevator"
        l2label.text = "New Elevator"
        l3label.text = "New Elevator"
        l4label.text = "New Elevator"

        r1label.text = "New Floor"
        r2label.text = "New Floor"
        r3label.text = "New Floor"
        r4label.text = "New Floor"

        r1button.setTitle("+", for: .normal)
        r2button.setTitle("+", for: .normal)
        r3button.setTitle("+", for: .normal)
        r4button.setTitle("+", for: .normal)
        favorites?.forEach { pref in
            let floor = String(pref.floor)
            switch pref.key {
            case KeyDef.L1: l1label.text = pref.favDescription
            case KeyDef.L2: l2label.text = pref.favDescription
            case KeyDef.L3: l3label.text = pref.favDescription
            case KeyDef.L4: l4label.text = pref.favDescription
            case KeyDef.R1:
                self.r1label.text = pref.favDescription
                self.r1button.setTitle(floor, for: .normal)
            case KeyDef.R2:
                self.r2label.text = pref.favDescription
                self.r2button.setTitle(floor, for: .normal)
            case KeyDef.R3:
                self.r3label.text = pref.favDescription
                self.r3button.setTitle(floor, for: .normal)
            case KeyDef.R4:
                self.r4label.text = pref.favDescription
                self.r4button.setTitle(floor, for: .normal)
            default: return
            }
        }
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
    }

    @IBAction func onR2Clicked(_ sender: Any) {
        onFavoriteClicked(KeyDef.R2)
    }

    @IBAction func onR3Clicked(_ sender: Any) {
        onFavoriteClicked(KeyDef.R3)
    }

    @IBAction func onR4Clicked(_ sender: Any) {
        onFavoriteClicked(KeyDef.R4)
    }

    @IBAction func onL1LongClicked(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            onFavoriteLongClicked(KeyDef.L1)
        }
    }
    
    @IBAction func onL2LongClicked(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            onFavoriteLongClicked(KeyDef.L2)
        }
    }
    
    @IBAction func onL3LongClicked(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            onFavoriteLongClicked(KeyDef.L3)
        }
    }
    
    @IBAction func onL4LongClicked(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            onFavoriteLongClicked(KeyDef.L4)
        }
    }
    
    @IBAction func onR1LongClicked(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            onFavoriteLongClicked(KeyDef.R1)
        }
    }
    
    @IBAction func onR2LongClicked(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            onFavoriteLongClicked(KeyDef.R2)
        }
    }
    
    @IBAction func onR3LongClicked(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            onFavoriteLongClicked(KeyDef.R3)
        }
    }
    
    @IBAction func onR4LongClicked(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            onFavoriteLongClicked(KeyDef.R4)
        }
    }
    
    func onFavoriteLongClicked(_ key: String) {
        let type = getType(key: key)
        
        if let favorite = favorites?.filter("key = %@", key).first {
            var message: String? = nil
            if type == TypeDef.TYPE_FLOOR {
                message = "Are you sure you would like to remove floor #\(favorite.floor) from \(favorite.favDescription ?? "elevator" )?"
            } else if type == TypeDef.TYPE_ELEVATOR {
                message = "Are you sure you would like to remove elevator \(favorite.favDescription ?? "")?"
            }
            let alert = UIAlertController(title: "Remove favorite?", message: message , preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Remove", comment: "Default action"), style: .destructive, handler: { _ in
                PreferencesRepository.sharedInstance.delete(entity: favorite)
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func onFavoriteClicked(_ key: String) {
        let type = getType(key: key)

        if let favorite = favorites?.filter("key = %@", key).first {
            if type == TypeDef.TYPE_FLOOR {
                toPanel(action: PanelAction(device: favorite.device, floor: favorite.floor))
            } else if type == TypeDef.TYPE_ELEVATOR {
                toPanel(action: PanelAction(device: favorite.device))
            }
        } else {
            buttonClicked = key
            if type == TypeDef.TYPE_FLOOR {
                toElevatorPicker(action: ElevatorAction.PickFloor)
            } else if type == TypeDef.TYPE_ELEVATOR {
                toElevatorPicker(action: ElevatorAction.PickElevator)
            }
        }
    }

    func getType(key: String) -> String? {
        switch (key) {
        case KeyDef.L1, KeyDef.L2, KeyDef.L3, KeyDef.L4:
            return TypeDef.TYPE_ELEVATOR
        case KeyDef.R1, KeyDef.R2, KeyDef.R3, KeyDef.R4:
            return TypeDef.TYPE_FLOOR
        default: return nil
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let elevatorPicker = segue.destination as? ElevatorsViewController {
            elevatorPicker.callback = { entity, floor in
                let favorite = FavoriteEntity()
                favorite.key = self.buttonClicked!
                favorite.favDescription = entity.elvDescription
                favorite.device = entity.device
                favorite.groupId = entity.groupId
                if let floor = floor {
                    favorite.type = TypeDef.TYPE_FLOOR
                    favorite.floor = floor
                } else {
                    favorite.type = TypeDef.TYPE_ELEVATOR
                }

                PreferencesRepository.sharedInstance.insert(favorite: favorite)
            }
        }
    }

    deinit {
        notificationToken?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
