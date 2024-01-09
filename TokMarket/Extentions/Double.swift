//
//  Double.swift
//  TokMarket
//
//  Created by KNG on 8.01.24.
//

import Foundation

import Foundation

extension Double {
    var percentFormat: String {
        return String(format: "%.3f", self) + "%"
    }
    
    var percentFormatTwoSymbol: String {
        return String(format: "%.2f", self) + "%"
    }
    
    var formatTwoSymbol: String {
        return String(format: "%.2f", self)
    }
    
    var formatFiveSymbol: String {
        return String(format: "%.5f", self)
    }
    
}
