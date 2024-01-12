//
//  Array.swift
//  TokMarket
//
//  Created by KNG on 10.01.24.
//

import Foundation

extension Array where Element: Equatable {
    func contains(array: [Element]) -> Bool {
        if self.isEmpty {
            return false
        }
        
        if array.isEmpty {
            return false
        }
        
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
}
