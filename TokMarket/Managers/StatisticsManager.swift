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
    
    static func avaragePriceBy(energyPrices: [EnergyPrice]) -> Double {
        var totalPrice: Double = 0.0
        var count: Double = 0.0
        for energyPrice in energyPrices {
            if let avaragePrice = CalculationManager.getAveragePriceTodayBy(energyPrice: energyPrice) {
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
    
    static func avarageVolumeBy(energyPrices: [EnergyPrice]) -> Double {
        var totalVolume: Double = 0.0
        var count: Double = 0.0
        for energyPrice in energyPrices {
            if let volume = CalculationManager.getAverageVolumeBy(energyPrice: energyPrice) {
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
    
    static func totalVolumeBy(energyPrices: [EnergyPrice], measuringUnits: MeasuringUnits) -> Double {
        var totalVolume: Double = 0.0
        
        for energyPrice in energyPrices {
            if let volume = CalculationManager.getTotalVolumeBy(energyPrice: energyPrice) {
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
}
