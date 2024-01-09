//
//  UserData.swift
//  TokMarket
//
//  Created by KNG on 9.01.24.
//

import Foundation

final class UserData {
    static var defaultCurrency: DefaultCurrency {
        get {
            return DefaultCurrency(rawValue: UserDefaults.standard.string(forKey: "DefaultCurrency") ?? "USD") ?? .bgn
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "DefaultCurrency")
            UserDefaults.standard.synchronize()
        }
    }

    static var defaultLanguage: DefaultLanguage {
        get {
            return DefaultLanguage(rawValue: UserDefaults.standard.string(forKey: "DefaultLanguage") ?? "en") ?? .english
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "DefaultLanguage")
            UserDefaults.standard.synchronize()
        }
    }
}
