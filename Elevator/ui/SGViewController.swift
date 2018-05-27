//
//  SGViewController.swift
//  Elevator
//
//  Created by Sinan Güneş on 22.01.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import UIKit
import RxSwift
import os.log

open class SGViewController: UIViewController {
    
    open let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    open let mainScheduler = MainScheduler.instance
    open let compositeDisposable = CompositeDisposable()
    
    open var intents = [String : Any]()
    
    // MARK: Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        if (kLog.TraceViews && kLog.Trace) {
            os_log("%@: viewDidLoad", String(describing: type(of: self)))
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (kLog.TraceViews && kLog.Trace) {
            os_log("%@: viewWillAppear", String(describing: type(of: self)))
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (kLog.TraceViews && kLog.Trace) {
            os_log("%@: viewDidAppear", String(describing: type(of: self)))
        }
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (kLog.TraceViews && kLog.Trace) {
            os_log("%@: viewWillDisappear", String(describing: type(of: self)))
        }
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        compositeDisposable.dispose()
        if (kLog.TraceViews && kLog.Trace) {
            os_log("%@: viewDidDisappear", String(describing: type(of: self)))
        }
    }

    // MARK: Navigation
    func toMain() {
        if !(self is MainViewController) {
            self.modalTransitionStyle = .crossDissolve
            performSegue(withIdentifier: "toMain", sender: self)
        }
    }

    func toPanel() {
        if !(self is PanelViewController) {
            self.modalTransitionStyle = .crossDissolve
            performSegue(withIdentifier: "toPanel", sender: self)
        }
    }
    
    func toGroupPicker(action:GroupAction) {
        if !(self is GroupsViewController) {
            self.modalTransitionStyle = .crossDissolve
            intents["toGroupPicker"] = action
            performSegue(withIdentifier: "toGroupPicker", sender: self)
        }
    }
    
    func toElevatorPicker(action:ElevatorAction) {
        if !(self is ElevatorsViewController) {
            self.modalTransitionStyle = .crossDissolve
            intents["toElevatorPicker"] = action
            performSegue(withIdentifier: "toElevatorPicker", sender: self)
        }
    }
    
    func toInfo(uuid:String) {
        if !(self is InfoViewController) {
            self.modalTransitionStyle = .crossDissolve
            intents["toInfo"] = uuid
            performSegue(withIdentifier: "toInfo", sender: self)
        }
    }
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let identifier = segue.identifier {
            if let intent = intents[identifier]{
                switch identifier {
                case "toGroupPicker":
                    let viewController = segue.destination as! GroupsViewController
                    viewController.intent = intent as? GroupAction
                    
                case "toInfo":
                    let viewController = segue.destination as! InfoViewController
                    viewController.intent = intent as? String
                    
                case "toElevatorPicker":
                    let viewController = segue.destination as! ElevatorsViewController
                    viewController.intent = intent as? ElevatorAction
                    
                default:
                    print("unhandled case: "+identifier)
                }
                
                intents[identifier] = nil
            }
        }
    }
    
    @IBAction func onDoneClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

