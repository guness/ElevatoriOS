//
//  ViewController.swift
//  Elevator
//
//  Created by Sinan Güneş on 21.01.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import UIKit
import RxSwift

class SplashViewController: SGViewController {

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

