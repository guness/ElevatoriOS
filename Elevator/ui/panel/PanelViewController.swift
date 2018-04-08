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
    var elevatorEntity:ElevatorEntity?=nil

    @IBOutlet weak var sevenSegment: UILabel!
    @IBOutlet weak var listView: UICollectionView!
    @IBOutlet weak var errorLabel: UILabel!
    
    let device = "UUID-0000-000-001"
    let group = "f5bbd000-d9c0-4bd5-b4c6-06d3ca605536"

    let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    let mainScheduler = MainScheduler.instance
    let compositeDisposable = CompositeDisposable()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        elevatorEntity = realm.objects(ElevatorEntity.self).filter("device = %@",device).first
        
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

        _ = compositeDisposable.insert(
                ElevatorRepository.sharedInstance
                        .getStateObservable()
                        .subscribeOn(backgroundScheduler)
                        .observeOn(mainScheduler)
                        .subscribe { it in
                            it.element
                        })

        _ = compositeDisposable.insert(
                ElevatorRepository.sharedInstance
                        .getOrderResponseObservable()
                        .subscribeOn(backgroundScheduler)
                        .observeOn(mainScheduler)
                        .subscribe { it in
                            it.element
                        })
        NetworkService.sharedInstance.sendListenDevice(device: device)
    }

    override func viewDidDisappear(_ animated: Bool) {
        compositeDisposable.dispose()
        NetworkService.sharedInstance.sendStopListenDevice(device: device)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elevatorEntity?.floorCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "ButtonCell";
        let cell:ButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ButtonCell
        cell.buttonView.setTitle("\(indexPath.item + (elevatorEntity?.minFloor ?? 0))", for: UIControlState.normal)
        return cell
    }
    
    
    @IBAction func onDoneClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
}

