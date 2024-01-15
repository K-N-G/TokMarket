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
        chartView.chartDescription.text = "Daily prices"
    }
}
