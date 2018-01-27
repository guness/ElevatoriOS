//
//  ViewController.swift
//  Elevator
//
//  Created by Sinan Güneş on 21.01.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import RxSwift
import UIKit

class SplashViewController: SGViewController {

    let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    let mainScheduler = MainScheduler.instance
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Single.just(true)
                .delay(RxTimeInterval(2), scheduler: MainScheduler.instance)
                .subscribeOn(backgroundScheduler)
                .observeOn(mainScheduler)
                .subscribe { _ in
                    self.toMain()
                }
                .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

