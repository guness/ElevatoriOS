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
    
    func toGroupList(action:GroupAction) {
        if !(self is GroupListViewController) {
            self.modalTransitionStyle = .crossDissolve
            intents["toGroupList"] = action
            performSegue(withIdentifier: "toGroupList", sender: self)
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
                case "toGroupList":
                    let viewController = segue.destination as! GroupListViewController
                    viewController.intent = intent as? GroupAction
                    
                case "toInfo":
                    let viewController = segue.destination as! InfoViewController
                    viewController.intent = intent as? String
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

