//
//  InitialViewController.swift
//  TokMarket
//
//  Created by KNG on 5.01.24.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.setObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "toAppSegue", sender: nil)
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        TimerManager.startTimers()
    }
    
    @objc func applicationDidEnterBackground(notification: NSNotification) {
        TimerManager.stopTimers()
    }
}
