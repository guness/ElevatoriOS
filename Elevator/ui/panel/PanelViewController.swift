//
//  PanelViewController.swift
//  Elevator
//
//  Created by Sinan Güneş on 22.01.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import UIKit
import RxSwift

class PanelViewController: SGViewController {

    let device = "f5bbd000-d9c0-4bd5-b4c6-06d3ca605536"

    let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    let mainScheduler = MainScheduler.instance
    let compositeDisposable = CompositeDisposable()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

    @IBAction func onDoneClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

