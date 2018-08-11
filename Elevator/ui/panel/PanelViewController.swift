//
//  PanelViewController.swift
//  Elevator
//
//  Created by Sinan Güneş on 22.01.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RealmSwift

class PanelViewController: SGViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var elevatorEntity: ElevatorEntity? = nil
    var intent: PanelAction? = nil
    var prefs: Results<PanelPrefsEntity>? = nil
    var notificationToken: NotificationToken? = nil
    var buttonClicked: String? = nil

    @IBOutlet weak var sevenSegment: UILabel!
    @IBOutlet weak var listView: UICollectionView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        prefs = realm.objects(PanelPrefsEntity.self).filter("device = %@", intent!.device)
        elevatorEntity = realm.objects(ElevatorEntity.self).filter("device = %@", intent!.device).first
        // Observe Results Notifications
        notificationToken = prefs?.observe { [weak self] (changes: RealmCollectionChange) in
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
        navigationItem.title = elevatorEntity?.elvDescription

        let token = InstanceID.instanceID().token()
        NetworkService.sharedInstance.connect(token)
    }

    func reloadButtonLabels() {
        button1.setTitle("+", for: .normal)
        button2.setTitle("+", for: .normal)
        button3.setTitle("+", for: .normal)
        button4.setTitle("+", for: .normal)
        prefs?.forEach { pref in
            let floor = String(pref.floor)
            switch pref.key {
            case KeyDef.B1: button1.setTitle(floor, for: .normal)
            case KeyDef.B2: button2.setTitle(floor, for: .normal)
            case KeyDef.B3: button3.setTitle(floor, for: .normal)
            case KeyDef.B4: button4.setTitle(floor, for: .normal)
            default: return
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let intent = intent {
            _ = compositeDisposable.insert(
                    ElevatorRepository.sharedInstance
                            .getStateObservable()
                            .filter {
                                $0.device == intent.device
                            }
                            .subscribeOn(backgroundScheduler)
                            .observeOn(mainScheduler)
                            .subscribe { it in
                                if let element = it.element {

                                    if let order = PreferencesRepository.sharedInstance.getOrder() {
                                        if order.device == element.device && order.floor == element.floor && element.action == "STOP" {
                                            PreferencesRepository.sharedInstance.clearOrder()
                                            SoundManager.sharedInstance.playDing()
                                        }
                                    }

                                    if element.online == true {
                                        self.sevenSegment.text = String(element.floor ?? 0)
                                    } else {
                                        self.sevenSegment.text = "OFF" //TODO: use strings
                                    }
                                } else {
                                    self.sevenSegment.text = "OFF" //TODO: use strings
                                }
                            })

            _ = compositeDisposable.insert(
                    ElevatorRepository.sharedInstance
                            .getOrderResponseObservable()
                            .filter {
                                $0.order?.device == intent.device
                            }
                            .map { element in
                                if element.success {
                                    self.errorLabel.text = ""
                                    PreferencesRepository.sharedInstance.insertOrder(device: element.order!.device, floor: element.order!.floor)
                                } else {
                                    self.errorLabel.text = "Service Failed"//TODO: use strings
                                    PreferencesRepository.sharedInstance.clearOrder()
                                }
                                return ""
                            }
                            .delay(RxTimeInterval(2), scheduler: backgroundScheduler)
                            .subscribeOn(backgroundScheduler)
                            .observeOn(mainScheduler)
                            .subscribe { it in
                                self.errorLabel.text = it.element!
                            })

            //TODO: handle better
            do {
                try NetworkService.sharedInstance.sendListenDevice(device: intent.device)
            } catch {
                displayError()
            }
            if let floor = intent.floor {
                sendRelayOrder(device: intent.device, floor: floor)
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        try? NetworkService.sharedInstance.sendStopListenDevice(device: intent!.device)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sendRelayOrder(device: intent!.device, floor: positionToFloor(position: indexPath.item))
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elevatorEntity?.floorCount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "ButtonCell";
        let cell: ButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ButtonCell
        let floor = positionToFloor(position: indexPath.item)
        cell.buttonView.setTitle("\(floor)", for: UIControlState.normal)
        cell.buttonView.floor = floor
        return cell
    }

    func sendRelayOrder(device: String, floor: Int) {
        do {
            try NetworkService.sharedInstance.sendRelayOrder(device: device, floor: floor)
        } catch {
            displayError()
        }
    }

    func displayError() {
        self.errorLabel.text = "Service Failed"//TODO: use strings
        _ = Observable.just("")
                .delay(RxTimeInterval(2), scheduler: backgroundScheduler)
                .subscribeOn(backgroundScheduler)
                .observeOn(mainScheduler)
                .subscribe { it in
                    self.errorLabel.text = ""
                }
    }

    @IBAction func onFloorSelected(_ sender: PanelButton) {
        if let intent = intent {
            sendRelayOrder(device: intent.device, floor: sender.floor)
        }
    }

    @IBAction func onB1Clicked(_ sender: Any) {
        onFavoriteClicked(KeyDef.B1)
    }

    @IBAction func onB2Clicked(_ sender: Any) {
        onFavoriteClicked(KeyDef.B2)
    }

    @IBAction func onB3Clicked(_ sender: Any) {
        onFavoriteClicked(KeyDef.B3)
    }

    @IBAction func onB4Clicked(_ sender: Any) {
        onFavoriteClicked(KeyDef.B4)
    }

    func onFavoriteClicked(_ key: String) {
        if let favorite = prefs?.filter("key = %@", key).first {
            sendRelayOrder(device: favorite.device, floor: favorite.floor)
        } else {
            buttonClicked = key
            toFloorPicker(action: elevatorEntity!)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let elevatorPicker = segue.destination as? FloorsViewController {
            elevatorPicker.callback = { entity, floor in
                let prefs = PanelPrefsEntity()
                prefs.key = self.buttonClicked!
                prefs.device = entity.device
                prefs.groupId = entity.groupId
                prefs.floor = floor

                PreferencesRepository.sharedInstance.insert(entity: prefs)
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

    func positionToFloor(position: Int) -> Int {
        return position + (elevatorEntity?.minFloor ?? 0)
    }

    func floorToPosition(floor: Int) -> Int {
        return floor - (elevatorEntity?.minFloor ?? 0)
    }
}


