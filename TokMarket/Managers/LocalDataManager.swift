//
//  LocalDataManager.swift
//  TokMarket
//
//  Created by KNG on 7.01.24.
//

import Foundation
import RealmSwift

enum LocalDataManagerError: Error {
    case wrongQueue
}

final class LocalDataManager {
    static let fetchEnergyPricesQueue = DispatchQueue(label: "FetchEnergyPricesQueue", qos: .background)
    
    static let realm: Realm = {
        return try! initializeRealm(checkForMainThread: true)
    }()
    
    static func backgroundRealm(queue: DispatchQueue = DispatchQueue.main) -> Realm {
        return try! initializeRealm(checkForMainThread: false, queue: queue)
    }

    class func initializeRealm(checkForMainThread: Bool = false, queue: DispatchQueue = DispatchQueue.main) throws -> Realm {
        if checkForMainThread {
            guard OperationQueue.current?.underlyingQueue == DispatchQueue.main else {
                throw LocalDataManagerError.wrongQueue
            }
        }
        do {
            return try Realm(configuration: realmConfiguration, queue: queue)
        } catch {
            throw error
        }
    }

    static let realmConfiguration: Realm.Configuration = {
        var configuration = Realm.Configuration.defaultConfiguration
        configuration.schemaVersion = 0
            configuration.migrationBlock = { (migration, version) in
                
        }
        return configuration
    }()
    
    static func fetchEnergyPrices() -> [EnergyPrice]? {
        try? LocalDataManager.realm.write {
            return Array(LocalDataManager.realm.objects(EnergyPrice.self))
        }
    }
    
    static func fetchEnergyPrice() -> EnergyPrice? {
        try? LocalDataManager.realm.write {
            return Array(LocalDataManager.realm.objects(EnergyPrice.self)).first(where: {$0.date == self.getCurrentDate()})
        }
    }
    
    static func getCurrentDate() -> String {
        var formattedDate = "01.01.2024"
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
    static func getCurrentHour() -> String {
        var formattedTime = "00:00:00"
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:00:00"
        formattedTime = dateFormatter.string(from: currentDate)
        return formattedTime
    }
    
    static func getCurrentHourDataBy(energyPrice: EnergyPrice) -> HourlyInfo? {
        let hourlyInfo = energyPrice.hourlyData.first(where: {$0.time == self.getCurrentHour()})?.data
        return hourlyInfo
    }
    
    static func getMinPriceTodayBy(energyPrice: EnergyPrice) -> Double? {
        var minPrice = 10000.0
        for hourlyInfo in energyPrice.hourlyData {
            if let price = hourlyInfo.data?.bgn,
               minPrice > price {
                minPrice = price
            }
        }
        return Double(minPrice.formatTwoSymbol)
    }
    
    static func getMaxPriceTodayBy(energyPrice: EnergyPrice) -> Double? {
        var maxPrice = -100.0
        for hourlyInfo in energyPrice.hourlyData {
            if let price = hourlyInfo.data?.bgn,
               maxPrice < price {
                maxPrice = price
            }
        }
        return Double(maxPrice.formatTwoSymbol)
    }
    
    static func getAveragePriceTodayBy(energyPrice: EnergyPrice) -> Double? {
        var count = 0.0
        var prices = 0.0
        for hourlyInfo in energyPrice.hourlyData {
            if let price = hourlyInfo.data?.bgn {
                count += 1.0
                prices += price
            }
        }
        return Double(Double(prices / count).formatTwoSymbol)
    }
}

