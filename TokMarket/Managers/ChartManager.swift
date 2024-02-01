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
    
    static func setupStatisticBarChart(barChartView: BarChartView, energyPrices: [EnergyPrice], statisticsType: StatisticsType) {
        var entries: [BarChartDataEntry] = []
        var count = 0.0
        for energyPrice in energyPrices {
            switch statisticsType {
            case .weeklyPrices, .monthlyPrices, .yearlyPrices:
                if let averagePrice = CalculationManager.getAveragePriceTodayBy(energyPrice: energyPrice) {
                    entries.append(BarChartDataEntry(x: count, y: averagePrice))
                    count += 1.0
                }
            case .weeklyVolume, .monthlyVolume, .yearlyVolume:
                if let averageVolume = CalculationManager.getAverageVolumeBy(energyPrice: energyPrice) {
                    entries.append(BarChartDataEntry(x: count, y: averageVolume))
                    count += 1.0
                }
               
            }
        }
        
        switch statisticsType {
        case .weeklyPrices, .weeklyVolume:
            for i in Int(count)..<7 {
                entries.append(BarChartDataEntry(x: Double(i), y: 1.0))
            }
        case .monthlyPrices, .monthlyVolume:
            for i in Int(count)..<StatisticsManager.daysInCurrentMonth() {
                entries.append(BarChartDataEntry(x: Double(i), y: 1.0))
            }
        default:
            break
        }
        
        var dataSetLabel = ""
        var dataSetColor = [UIColor.blue]
        switch statisticsType {
        case .weeklyPrices, .monthlyPrices, .yearlyPrices:
            dataSetLabel = "\("average_price".localized): \(UserData.defaultCurrency.rawValue) / \(MeasuringUnits.mWh.rawValue)"
            dataSetColor = [.blueberryBlue]
        case .weeklyVolume, .monthlyVolume, .yearlyVolume:
            dataSetLabel = "\("average_volume".localized): \(MeasuringUnits.mWh.rawValue) / h"
            dataSetColor = [.bloodyRed]
        }
        
        

        let dataSet = BarChartDataSet(entries: entries, label: dataSetLabel)
        dataSet.colors = dataSetColor
        dataSet.drawValuesEnabled = false
        
        let groupCount = max(entries.count, 7)
        let startYear = 0

        let barChartData = BarChartData(dataSets: [dataSet])
        barChartData.barWidth = 0.45
        barChartView.xAxis.axisMinimum = Double(startYear)
        let groupWidth = barChartData.groupWidth(groupSpace: 0.06, barSpace: 0.02)
        barChartView.xAxis.axisMaximum = Double(startYear) + (groupWidth * Double(groupCount))
        barChartData.groupBars(fromX: Double(startYear), groupSpace: 0.06, barSpace: 0.02)

        barChartView.data = barChartData
        barChartView.gridBackgroundColor = .red
        barChartView.pinchZoomEnabled = false
        barChartView.drawGridBackgroundEnabled = false
        
        barChartView.xAxis.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.animate(yAxisDuration: TimeInterval(2))
    }

}
