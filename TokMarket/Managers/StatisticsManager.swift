//
//  StatisticsManager.swift
//  TokMarket
//
//  Created by KNG on 28.01.24.
//

import Foundation

final class StatisticsManager {
    static let currentDate = Date()
    static let calendar = Calendar.current
    static let dateFormatter = DateFormatter()
    
    static func fetchWeeklyData() -> [EnergyPrice] {
        var weeklyData: [EnergyPrice] = []
        guard let energyPrices = LocalDataManager.fetchEnergyPrices() else {
            return weeklyData
        }
        let currentDateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        weeklyData = energyPrices.filter { energyPrice in
            if let energyPriceDate = energyPrice.date,
               let energyDate = dateFormatter.date(from: energyPriceDate) {
                let energyDateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: energyDate)
                return energyDateComponents == currentDateComponents
            }
            return false
        }
        return weeklyData.reversed()
    }
    
    static func fetchMonthlyData() -> [EnergyPrice] {
        var monthlyData: [EnergyPrice] = []
        guard let energyPrices = LocalDataManager.fetchEnergyPrices() else {
            return monthlyData
        }
        
        let currentDateComponents = calendar.dateComponents([.year, .month], from: currentDate)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        monthlyData = energyPrices.filter { energyPrice in
            if let energyPriceDate = energyPrice.date,
               let energyDate = dateFormatter.date(from: energyPriceDate) {
                let energyDateComponents = calendar.dateComponents([.year, .month], from: energyDate)
                return energyDateComponents == currentDateComponents
            }
            return false
        }
        
        return monthlyData.reversed()
    }
    
    static func fetchYearlyData() -> [EnergyPrice] {
        var yearlyData: [EnergyPrice] = []
        guard let energyPrices = LocalDataManager.fetchEnergyPrices() else {
            return yearlyData
        }
        
        let currentDateComponents = calendar.dateComponents([.year], from: currentDate)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        yearlyData = energyPrices.filter { energyPrice in
            if let energyPriceDate = energyPrice.date,
               let energyDate = dateFormatter.date(from: energyPriceDate) {
                let energyDateComponents = calendar.dateComponents([.year], from: energyDate)
                return energyDateComponents == currentDateComponents
            }
            return false
        }
        
        return yearlyData.reversed()
    }
    
    static func daysInCurrentMonth() -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        if let monthRange = calendar.range(of: .day, in: .month, for: currentDate) {
            let numberOfDays = monthRange.count
            return numberOfDays
        }

        return 0
    }
    
    static func avaragePriceBy(energyPrices: [EnergyPrice], marketType: MarketType = .base) -> Double {
        var totalPrice: Double = 0.0
        var count: Double = 0.0
        for energyPrice in energyPrices {
            if let avaragePrice = CalculationManager.getAveragePriceBy(energyPrice: energyPrice, marketType: marketType) {
                totalPrice += avaragePrice
                count += 1.0
            }
        }
        
        if totalPrice > 0 || count > 0 {
            return totalPrice / count
        } else {
            return 0.0
        }
    }
    
    static func avarageVolumeBy(energyPrices: [EnergyPrice], marketType: MarketType = .base) -> Double {
        var totalVolume: Double = 0.0
        var count: Double = 0.0
        for energyPrice in energyPrices {
            if let volume = CalculationManager.getAverageVolumeBy(energyPrice: energyPrice, marketType: marketType) {
                totalVolume += volume
                count += 1.0
            }
        }
        
        if totalVolume > 0 || count > 0 {
            return totalVolume / count
            
        } else {
            return 0.0
        }
    }
    
    static func totalVolumeBy(energyPrices: [EnergyPrice], measuringUnits: MeasuringUnits, marketType: MarketType = .base) -> Double {
        var totalVolume: Double = 0.0
        
        for energyPrice in energyPrices {
            if let volume = CalculationManager.getTotalVolumeBy(energyPrice: energyPrice, marketType: marketType) {
                totalVolume += volume
            }
        }
        switch measuringUnits {
        case .kWh:
            return totalVolume * 1000
        case .mWh:
            return totalVolume
        case .gWh:
            return totalVolume / 1000
        case .tWh:
            return totalVolume / 1000000
        }
    }
    
    static func minPriceBy(energyPrices: [EnergyPrice], marketType: MarketType = .base) -> Double {
        var minPrice = 10000.0
        for energyPrice in energyPrices {
            if let price = CalculationManager.getMinPriceTodayBy(energyPrice: energyPrice, marketType: marketType),
               minPrice > price {
                minPrice = price
            }
        }
        return minPrice
    }
    
    static func minVolumeBy(energyPrices: [EnergyPrice], marketType: MarketType = .base) -> Double {
        var minVolume = 100000.0
        for energyPrice in energyPrices {
            if let volume = CalculationManager.getMinVolumeTodayBy(energyPrice: energyPrice, marketType: marketType),
               minVolume > volume {
                minVolume = volume
            }
        }
        return minVolume
    }
    
    static func maxPriceBy(energyPrices: [EnergyPrice], marketType: MarketType = .base) -> Double {
        var maxPrice = -100.0
        for energyPrice in energyPrices {
            if let price = CalculationManager.getMaxPriceTodayBy(energyPrice: energyPrice, marketType: marketType),
                maxPrice < price {
                 maxPrice = price
            }
        }
        return maxPrice
    }
    
    static func maxVolumeBy(energyPrices: [EnergyPrice], marketType: MarketType = .base) -> Double {
        var maxVolume = -100.0
        for energyPrice in energyPrices {
            if let volume = CalculationManager.getMinVolumeTodayBy(energyPrice: energyPrice, marketType: marketType),
               maxVolume < volume {
                maxVolume = volume
            }
        }
        return maxVolume
    }
}
