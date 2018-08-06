//
//  ElevatorPickerViewController.swift
//  Elevator
//
//  Created by Sinan Güneş on 27.05.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RealmSwift

class ElevatorsViewController: SGViewController, UITableViewDataSource, UITableViewDelegate {

    var notificationToken: NotificationToken? = nil
    var groups: Results<GroupEntity>? = nil
    var intent: ElevatorAction? = nil
    var callback : ((ElevatorEntity, Int?) -> Void)?

    @IBOutlet weak var listView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if intent == ElevatorAction.PickElevator {

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        groups = realm.objects(GroupEntity.self)

        // Observe Results Notifications
        notificationToken = groups?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let listView = self?.listView else {
                return
            }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                listView.reloadData()
            case .update(_, _, _, _):
                // Query results have changed, so apply them to the UITableView
                listView.reloadData()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return groups?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groups?[section].groupDescription
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?[section].elevators.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let elevator = self.groups?[indexPath.section].elevators[indexPath.row]
        let identifier = "ElevatorCell";
        //TODO: move this to a constant
        let cell: ElevatorCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ElevatorCell
        cell.textLabel?.text = elevator?.elvDescription
        cell.imageView?.image = UIImage(named: "Elevator")
        //cell.buttonView.setTitle("\(indexPath.item + (elevatorEntity?.minFloor ?? 0))", for: UIControlState.normal)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let elevator = self.groups?[indexPath.section].elevators[indexPath.row]
        if intent == ElevatorAction.PickElevator {
            callback?(elevator!, nil)
            navigationController?.popViewController(animated: true)
        } else if intent == ElevatorAction.PickFloor {
            toFloorPicker(action:elevator!)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let floorPicker = segue.destination as? FloorsViewController {
            floorPicker.callback = { entity, floor in
                self.callback?(entity, floor)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
