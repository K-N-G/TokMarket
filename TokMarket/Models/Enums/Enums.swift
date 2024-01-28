//
//  Enums.swift
//  TokMarket
//
//  Created by KNG on 9.01.24.
//

import Foundation

enum DefaultCurrency: String {
    case bgn = "лв"
    case eur = "EUR"
}

enum DefaultLanguage: String {
    case bulgarian = "bg"
    case english = "en"
}

enum MeasuringUnits: String {
    case kWh
    case mWh
    case gWh
    case tWh
}

enum StatisticsType: String {
    case weeklyPrices = "weekly_statistics_prices"
    case weeklyVolume = "weekly_statistics_volume"
    case monthlyPrices = "monthly_statistics_prices"
    case monthlyVolume = "monthly_statistics_volume"
    case yearlyPrices = "yearly_statistics_prices"
    case yearlyVolume = "yearly_statistics_volume"
    
}
