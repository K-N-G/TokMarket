//
//  TimerManager.swift
//  TokMarket
//
//  Created by KNG on 12.01.24.
//

import Foundation

final class TimerManager {
    static private var pricesTimer = Timer()
    static private var updateScreenTimers = Timer()
    
    static func startTimers() {
        self.stopTimers()
        print("Start timers")
        fetchPrices()
        updateScreens()
    }

    static func stopTimers() {
        print("Stop timers")
        pricesTimer.invalidate()
        updateScreenTimers.invalidate()
        
    }
    
    static private func fetchPrices() {
        updatePrices()
        pricesTimer = Timer.scheduledTimer(withTimeInterval: 3600.0, repeats: true, block: { _ in
            updatePrices()
        })
    }
    
    static private func updateScreens() {
        updateScreenInfo()
        pricesTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            updateScreenInfo()
        })
    }
    
    static private func updatePrices() {
        PriceManager.fetchLatestEnergyPricesDate(completion: {energyPrice, error in
            guard let lastServiceDate = energyPrice,
            let lastDataBaseDate = LocalDataManager.fetchEnergyPrices()?.first?.date else {
                return
            }
            if lastDataBaseDate == lastServiceDate { return }
            PriceManager.fetchEnergyPrices(completion: {error in
                NotificationCenter.default.post(name: .updateScreen, object: nil)
            })
        })
    }
    
    static private func updateScreenInfo() {
        if UserData.currentDashboardHour == LocalDataManager.getCurrentHour() { return }
        UserData.currentDashboardHour = LocalDataManager.getCurrentHour()
        NotificationCenter.default.post(name: .updateScreen, object: nil)
    }
}
