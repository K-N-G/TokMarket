//
//  LatestPriceDate.swift
//  TokMarket
//
//  Created by KNG on 12.01.24.
//

import Foundation

struct LatestPriceDate: Codable {
    let latestDate: String

    enum CodingKeys: String, CodingKey {
        case latestDate = "latest date"
    }
}
