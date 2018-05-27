//
//  GroupsViewController.swift
//  Elevator
//
//  Created by Sinan Güneş on 13.05.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class GroupsViewController: SGViewController, UITableViewDataSource, UITableViewDelegate {
    
    var notificationToken: NotificationToken? = nil
    var groups: Results<GroupEntity>? = nil
    var intent: GroupAction? = nil
    
    @IBOutlet weak var listView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if intent == GroupAction.Delete {
            listView.isEditing = true
        }
    }
    
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
            case .update(_,  _,  _,  _):
                // Query results have changed, so apply them to the UITableView
                listView.reloadData()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = self.groups?[indexPath.row]
        let identifier = "GroupCell"; //TODO: move this to a constant
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = group?.groupDescription
        //cell.buttonView.setTitle("\(indexPath.item + (elevatorEntity?.minFloor ?? 0))", for: UIControlState.normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let group = self.groups?[indexPath.row]{
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(group)
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
