//
//  PanelViewController.swift
//  Elevator
//
//  Created by Sinan Güneş on 22.01.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class PanelViewController: SGViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var notificationToken: NotificationToken? = nil
    var elevatorEntity: ElevatorEntity? = nil
    var intent: PanelAction? = nil

    @IBOutlet weak var sevenSegment: UILabel!
    @IBOutlet weak var listView: UICollectionView!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        elevatorEntity = realm.objects(ElevatorEntity.self).filter("device = %@", intent!.device).first

        // Observe Results Notifications
        notificationToken = elevatorEntity?.observe { change in
            switch change {
            case .change(let properties):
                for property in properties {
                    if property.name == "steps" && property.newValue as! Int > 1000 {
                        print("Congratulations, you've exceeded 1000 steps.")
                    }
                }
            case .error(let error):
                print("An error occurred: \(error)")
            case .deleted:
                print("The object was deleted.")
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
                            .subscribe {it in
                                self.errorLabel.text = it.element!
                            })

            NetworkService.sharedInstance.sendListenDevice(device: intent.device)

            if let floor = intent.floor {
                NetworkService.sharedInstance.sendRelayOrder(device: intent.device, floor: floor)
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NetworkService.sharedInstance.sendStopListenDevice(device: intent!.device)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NetworkService.sharedInstance.sendRelayOrder(device: intent!.device, floor: positionToFloor(position: indexPath.item))
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

    @IBAction func onFloorSelected(_ sender: PanelButton) {
        if let intent = intent {
            NetworkService.sharedInstance.sendRelayOrder(device: intent.device, floor: sender.floor)
        }
    }

    @IBAction func onB1Clicked(_ sender: Any) {
    }

    @IBAction func onB2Clicked(_ sender: Any) {
    }

    @IBAction func onB3Clicked(_ sender: Any) {
    }

    @IBAction func onB4Clicked(_ sender: Any) {
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


