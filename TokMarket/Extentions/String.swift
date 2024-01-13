//
//  String.swift
//  TokMarket
//
//  Created by KNG on 13.01.24.
//

import Foundation

extension String {
    var localized: String {
        if let path = Bundle.main.path(forResource: UserData.defaultLanguage.rawValue.lowercased(), ofType: "lproj"),
           let bundle  = Bundle(path: path) {
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        }
        return self
    }
}
