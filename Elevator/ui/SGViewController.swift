//
//  SGViewController.swift
//  Elevator
//
//  Created by Sinan Güneş on 22.01.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import UIKit
import os.log

open class SGViewController: UIViewController {
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
        if (kLog.TraceViews && kLog.Trace) {
            os_log("%@: viewDidDisappear", String(describing: type(of: self)))
        }
    }
    // MARK: Navigation
    func toMain(){
        if !(self is MainViewController) {
            performSegue(withIdentifier: "toMain", sender: self)
        }
    }
}

