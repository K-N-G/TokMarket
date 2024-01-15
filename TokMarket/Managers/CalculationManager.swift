//
//  StatisticsManager.swift
//  TokMarket
//
//  Created by KNG on 9.01.24.
//

import Foundation

final class CalculationManager {
    
    static let peakHours = ["08:00:00", "09:00:00", "10:00:00", "11:00:00", "12:00:00", "13:00:00", "14:00:00", "15:00:00", "16:00:00", "17:00:00", "18:00:00", "19:00:00"]
    
    static func getMinPriceTodayBy(energyPrice: EnergyPrice) -> Double? {
        var minPrice = 10000.0
        for hourlyData in energyPrice.hourlyData {
            if let price = LocalDataManager.getPriceBy(hourlyData: hourlyData),
               minPrice > price {
                minPrice = price
            }
        }
        return Double(minPrice.formatTwoSymbol)
    }
    
    static func getMinHourlyDataBy(energyPrice: EnergyPrice) -> HourlyData? {
        var minHourlyData: HourlyData?
        var minPrice = 10000.0
        for hourlyData in energyPrice.hourlyData {
            if let price = LocalDataManager.getPriceBy(hourlyData: hourlyData),
               minPrice > price {
                minPrice = price
                minHourlyData = hourlyData
            }
        }
        return minHourlyData
    }
    
    static func getMaxPriceTodayBy(energyPrice: EnergyPrice) -> Double? {
        var maxPrice = -100.0
        for hourlyData in energyPrice.hourlyData {
            if let price = LocalDataManager.getPriceBy(hourlyData: hourlyData),
               maxPrice < price {
                maxPrice = price
            }
        }
        return Double(maxPrice.formatTwoSymbol)
    }
    
    static func getMaxHourlyDataBy(energyPrice: EnergyPrice) -> HourlyData? {
        var maxHourlyData: HourlyData?
        var maxPrice = -100.0
        for hourlyData in energyPrice.hourlyData {
            if let price = LocalDataManager.getPriceBy(hourlyData: hourlyData),
               maxPrice < price {
                maxPrice = price
                maxHourlyData = hourlyData
            }
        }
        return maxHourlyData
    }
    
    static func getAveragePriceTodayBy(energyPrice: EnergyPrice) -> Double? {
        var count = 0.0
        var prices = 0.0
        for hourlyData in energyPrice.hourlyData {
            if let price = LocalDataManager.getPriceBy(hourlyData: hourlyData) {
                count += 1.0
                prices += price
            }
        }
        return Double(Double(prices / count).formatTwoSymbol)
    }
    
    static func getAveragePricePeakBy(energyPrice: EnergyPrice) -> Double? {
        var count = 0.0
        var prices = 0.0
        for hourlyData in energyPrice.hourlyData {
            if peakHours.contains(hourlyData.time) {
                if let price = LocalDataManager.getPriceBy(hourlyData: hourlyData) {
                    count += 1.0
                    prices += price
                }
            }
        }
        return Double(Double(prices / count).formatTwoSymbol)
    }
    
    static func getAveragePriceOffPeakBy(energyPrice: EnergyPrice) -> Double? {
        var count = 0.0
        var prices = 0.0
        for hourlyData in energyPrice.hourlyData {
            if !(peakHours.contains(hourlyData.time)) {
                if let price = LocalDataManager.getPriceBy(hourlyData: hourlyData) {
                    count += 1.0
                    prices += price
                }
            }
        }
        return Double(Double(prices / count).formatTwoSymbol)
    }
    
    static func getTotalVolumeBy(energyPrice: EnergyPrice) -> Double? {
        var totalVolume = 0.0
        for hourlyInfo in energyPrice.hourlyData {
            if let volume = hourlyInfo.data?.volume {
                totalVolume += volume
            }
        }
        return Double(Double(totalVolume).formatTwoSymbol)
    }
    
    static func getPeriodBy(time: String) -> String {
        var period = "---"
        switch time {
        case "00:00:00", "0":
            period = "0 - 1"
        case "01:00:00", "1":
            period = "1 - 2"
        case "02:00:00", "2":
            period = "2 - 3"
        case "03:00:00", "3":
            period = "3 - 4"
        case "04:00:00", "4":
            period = "4 - 5"
        case "05:00:00", "5":
            period = "5 - 6"
        case "06:00:00", "6":
            period = "6 - 7"
        case "07:00:00", "7":
            period = "7 - 8"
        case "08:00:00", "8":
            period = "8 - 9"
        case "09:00:00", "9":
            period = "9 - 10"
        case "10:00:00", "10":
            period = "10 - 11"
        case "11:00:00", "11":
            period = "11 - 12"
        case "12:00:00", "12":
            period = "12 - 13"
        case "13:00:00", "13":
            period = "13 - 14"
        case "14:00:00", "14":
            period = "14 - 15"
        case "15:00:00", "15":
            period = "15 - 16"
        case "16:00:00", "16":
            period = "16 - 17"
        case "17:00:00", "17":
            period = "17 - 18"
        case "18:00:00", "18":
            period = "18 - 19"
        case "19:00:00", "19":
            period = "19 - 20"
        case "20:00:00", "20":
            period = "20 - 21"
        case "21:00:00", "21":
            period = "21 - 22"
        case "22:00:00", "22":
            period = "22 - 23"
        case "23:00:00", "23":
            period = "23 - 0"
        default:
            break
        }
        return period
    }
}
