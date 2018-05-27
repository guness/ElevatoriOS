//
//  MenuViewController.swift
//  Elevator
//
//  Created by Sinan Güneş on 23.01.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class MenuViewController: SGViewController, UITableViewDataSource, UITableViewDelegate {

    var notificationToken: NotificationToken? = nil
    var groups: Results<GroupEntity>? = nil
    
    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        groups = realm.objects(GroupEntity.self)
        
        // Observe Results Notifications
        notificationToken = groups?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let listView = self?.listView else { return }
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
        return (groups?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (groups?.count ?? 0 == section){
            return nil
        } else {
            return groups?[section].groupDescription
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (groups?.count ?? 0 == section){
            return 1
        } else {
            return groups?[section].elevators.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (groups?.count ?? 0 == indexPath.section){
            let identifier = "DeleteCell"; //TODO: move this to a constant
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            return cell
        } else {
            let elevator = self.groups?[indexPath.section].elevators[indexPath.row]
            let identifier = "MenuCell"; //TODO: move this to a constant
            let cell:MenuCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MenuCell
            cell.textLabel?.text = elevator?.elvDescription
            cell.imageView?.image = UIImage(named: "Elevator")
            //cell.buttonView.setTitle("\(indexPath.item + (elevatorEntity?.minFloor ?? 0))", for: UIControlState.normal)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if (groups?.count ?? 0 == indexPath.section){
            toGroupList(action: GroupAction.Delete)
        } else {
            //TODO:
        }
    }

    @IBAction func unwindToMenu(segue:UIStoryboardSegue) {
        
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

