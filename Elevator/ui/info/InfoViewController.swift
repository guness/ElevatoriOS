//
//  InfoViewController.swift
//  Elevator
//
//  Created by Sinan Güneş on 26.05.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class InfoViewController: SGViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    var intent: String? = nil
    var group: Group? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let uuid = intent{
            
            _ = compositeDisposable.insert(
                ElevatorRepository.sharedInstance
                    .getGroupInfoObservable()
                    .filter {$0.group?.uuid == uuid}
                    .subscribeOn(backgroundScheduler)
                    .observeOn(mainScheduler)
                    .subscribe { it in
                        self.group = it.element?.group
                        self.listView.reloadData()
                        self.progressIndicator.stopAnimating()
                    })
            
            NetworkService.sharedInstance.fetchUUID(uuid)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         switch section {
        case 0:
            return "Description"
        case 1:
            return "Address"
        case 2:
            return "Elevator Count"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier:String //TODO: move this to a constant
        let data:String?
        switch indexPath.section {
        case 0:
            identifier = "BasicCell"
            data = self.group?.description
        case 1:
            identifier = "LargeCell"
            data = self.group?.address
        default:
            identifier = "BasicCell"
            data = "\((self.group?.elevators.count ?? 0))"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = data
        return cell
    }
    
    override func onDoneClicked(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
}
