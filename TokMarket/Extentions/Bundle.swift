//
//  Bundle.swift
//  TokMarket
//
//  Created by KNG on 13.01.24.
//

import Foundation

extension Bundle {
    var applicationVersion: String {
        return infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    var applicationBuildVersion: String {
        return infoDictionary!["CFBundleVersion"] as! String
    }
}
