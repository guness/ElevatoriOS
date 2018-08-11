//
//  FloorsViewController.swift
//  Elevator
//
//  Created by Sinan Güneş on 6.08.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RealmSwift

class FloorsViewController: SGViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var intent: ElevatorEntity? = nil
    var callback : ((ElevatorEntity, Int) -> Void)?
    
    @IBOutlet weak var listView: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = intent?.elvDescription
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return intent?.floorCount ?? 0
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
            callback?(intent, sender.floor)
            onDoneClicked(sender)
        }
    }
    
    override func onDoneClicked(_ sender: Any) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func positionToFloor(position: Int) -> Int {
        return position + (intent?.minFloor ?? 0)
    }
    
    func floorToPosition(floor: Int) -> Int {
        return floor - (intent?.minFloor ?? 0)
    }
}
