//
//  ChartManager.swift
//  TokMarket
//
//  Created by KNG on 14.01.24.
//

import Foundation
import UIKit
import DGCharts

final class ChartManager {
    static func setupLineChart(chartView: LineChartView, energyPrice: EnergyPrice) {
        var entries: [ChartDataEntry] = []
        var countHour = 0.0
        for hourlyData in energyPrice.hourlyData {
            if let eur = hourlyData.data?.eur,
               let bgn = hourlyData.data?.bgn {
                let xValue = countHour
                countHour += 1.0
                let yValue = UserData.defaultCurrency == .bgn ?  bgn : eur
                entries.append(ChartDataEntry(x: xValue, y: yValue))
            }
        }

        let dataSet = LineChartDataSet(entries: entries, label: "\(UserData.defaultCurrency.rawValue) prices")
        dataSet.colors = [NSUIColor.blue]
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawFilledEnabled = false
        dataSet.lineWidth = 3
        dataSet.setColor(UIColor.red)
        dataSet.fillAlpha = 1.0
        let gradientColors =  [UIColor(named: "blueberryBlue")?.cgColor, UIColor(named: "kindaWhite")?.cgColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.4]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90)
        dataSet.drawFilledEnabled = true
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
        chartView.gridBackgroundColor = .red
        chartView.pinchZoomEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.xAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.legend.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelCount = 4
        chartView.xAxis.valueFormatter = nil
        chartView.minOffset = 0
        chartView.xAxis.granularity = 1.0
        chartView.chartDescription.text = "daily_prices".localized
    }
    
    static func setupStatisticLineChart(chartView: LineChartView, energyPrices: [EnergyPrice], statisticsType: StatisticsType) {
        var entries: [ChartDataEntry] = []
        var count = 0.0
        for energyPrice in energyPrices {
            if energyPrices.count <= 2 {
                entries.append(ChartDataEntry(x: 0.0, y: 0.0))
                count += 1
            }
            switch statisticsType {
            case .weeklyPrices, .monthlyPrices, .yearlyPrices:
                if let avaregePrice = CalculationManager.getAveragePriceTodayBy(energyPrice: energyPrice) {
                    entries.append(ChartDataEntry(x: count, y: avaregePrice))
                    count += 1.0
                }
            case .weeklyVolume, .monthlyVolume, .yearlyVolume:
                if let avaregePrice = CalculationManager.getAverageVolumeBy(energyPrice: energyPrice) {
                    entries.append(ChartDataEntry(x: count, y: avaregePrice))
                    count += 1.0
                }
            }
            if energyPrices.count <= 2 {
                entries.append(ChartDataEntry(x: Double(energyPrices.count + 1), y: 0.0))
            }
        }

        let dataSet = LineChartDataSet(entries: entries, label: "\(UserData.defaultCurrency.rawValue) prices")
        dataSet.colors = [NSUIColor.blue]
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawFilledEnabled = false
        dataSet.lineWidth = 3
        dataSet.setColor(UIColor.red)
        dataSet.fillAlpha = 1.0
        let gradientColors =  [UIColor(named: "blueberryBlue")?.cgColor, UIColor(named: "kindaWhite")?.cgColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.4]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90)
        dataSet.drawFilledEnabled = true
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
        chartView.gridBackgroundColor = .red
        chartView.pinchZoomEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.xAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.legend.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelCount = 4
        chartView.xAxis.valueFormatter = nil
        chartView.minOffset = 0
        chartView.xAxis.granularity = 1.0
        switch statisticsType {
        case .weeklyPrices:
            chartView.chartDescription.text = "weekly_prices".localized
        case .weeklyVolume:
            chartView.chartDescription.text = "weekly_volume".localized
        case .monthlyPrices:
            chartView.chartDescription.text = "monthly_prices".localized
        case .monthlyVolume:
            chartView.chartDescription.text = "monthly_volume".localized
        case .yearlyPrices:
            chartView.chartDescription.text = "yearly_prices".localized
        case .yearlyVolume:
            chartView.chartDescription.text = "yearly_volume".localized
        }
        
    }
}
