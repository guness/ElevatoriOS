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
    var group: GroupEntity? = nil
    var intent: ElevatorAction? = nil
    
    @IBOutlet weak var listView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if intent == ElevatorAction.Pick {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        group = realm.objects(GroupEntity.self).first //TODO:FIXME
        
        // Observe Results Notifications
        notificationToken = group?.observe { [weak self] (changes: ObjectChange) in
            guard let listView = self?.listView else { return }
            switch changes {
            case .deleted:
                self!.dismiss(animated: false)
            case .change(_):
                // Query results have changed, so apply them to the UITableView
                listView.reloadData()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group?.elevators.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let elevator = self.group?.elevators[indexPath.row]
        let identifier = "ElevatorCell"; //TODO: move this to a constant
        let cell:ElevatorCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ElevatorCell
        cell.textLabel?.text = elevator?.elvDescription
        return cell
    }
}
