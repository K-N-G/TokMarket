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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "toAppSegue", sender: nil)
    }
}
