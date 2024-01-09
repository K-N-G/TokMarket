//
//  Notification.swift
//  TokMarket
//
//  Created by KNG on 9.01.24.
//

import Foundation

extension NSNotification.Name {
    static let addressDataUpdated = NSNotification.Name(rawValue: "addressDataUpdated")
    static let updatePrice = NSNotification.Name(rawValue: "UpdatePrice")
    static let updateSwapAndStake = NSNotification.Name(rawValue: "UpdateSwapAndStake")
}

extension NotificationCenter {
    func setObserver(_ observer: AnyObject, selector: Selector, name: NSNotification.Name, object: AnyObject?) {
        NotificationCenter.default.removeObserver(observer,
                                                  name: name,
                                                  object: object)
        NotificationCenter.default.addObserver(observer,
                                               selector: selector,
                                               name: name,
                                               object: object)
    }
}
