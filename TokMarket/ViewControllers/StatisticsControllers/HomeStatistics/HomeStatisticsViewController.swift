//
//  HomeStatisticsViewController.swift
//  TokMarket
//
//  Created by KNG on 5.01.24.
//

import UIKit
import GoogleMobileAds

class HomeStatisticsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var rows: [StatisticsRow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
    }
    
    func setupScreen() {
        let weeklyData = StatisticsManager.fetchWeeklyData()
        let monthlyData = StatisticsManager.fetchMonthlyData()
        let yearlyData = StatisticsManager.fetchYearlyData()
        
        self.rows = [
            StatisticsRow(type: .statistics, 
                          statisticType: .weeklyPrices,
                          leftTitle: "average_price".localized,
                          leftValue: StatisticsManager.avaragePriceBy(energyPrices: weeklyData).formatTwoSymbol,
                          leftValueType: MeasuringUnits.mWh.rawValue.localized,
                          rightViewIsHidden: true, 
                          energyPrices: weeklyData),
            StatisticsRow(type: .statistics,
                          statisticType: .weeklyVolume,
                          leftTitle: "average_volume".localized,
                          leftValue: StatisticsManager.avarageVolumeBy(energyPrices: weeklyData).formatTwoSymbol,
                          leftValueType: MeasuringUnits.mWh.rawValue.localized,
                          rightTitle: "total_volume".localized,
                          rightValue: StatisticsManager.totalVolumeBy(energyPrices: weeklyData, measuringUnits: .gWh).formatTwoSymbol,
                          rightValueType: MeasuringUnits.gWh.rawValue.localized,
                          energyPrices: weeklyData),
            StatisticsRow(type: .ad),
            StatisticsRow(type: .statistics,
                          statisticType: .monthlyPrices,
                          leftTitle: "average_price".localized,
                          leftValue: StatisticsManager.avaragePriceBy(energyPrices: monthlyData).formatTwoSymbol,
                          leftValueType: MeasuringUnits.mWh.rawValue.localized,
                          rightViewIsHidden: true, 
                          energyPrices: monthlyData),
            StatisticsRow(type: .statistics,
                          statisticType: .monthlyVolume,
                          leftTitle: "average_volume".localized,
                          leftValue: StatisticsManager.avarageVolumeBy(energyPrices: monthlyData).formatTwoSymbol,
                          leftValueType: MeasuringUnits.mWh.rawValue.localized,
                          rightTitle: "total_volume".localized,
                          rightValue: StatisticsManager.totalVolumeBy(energyPrices: monthlyData, measuringUnits: .gWh).formatTwoSymbol,
                          rightValueType: MeasuringUnits.gWh.rawValue.localized,
                          energyPrices: monthlyData),
            StatisticsRow(type: .ad),
            StatisticsRow(type: .statistics,
                          statisticType: .yearlyPrices,
                          leftTitle: "average_price".localized,
                          leftValue: StatisticsManager.avaragePriceBy(energyPrices: yearlyData).formatTwoSymbol,
                          leftValueType: MeasuringUnits.mWh.rawValue.localized,
                          rightViewIsHidden: true, 
                          energyPrices: yearlyData),
            StatisticsRow(type: .statistics,
                          statisticType: .yearlyVolume,
                          leftTitle: "average_volume".localized,
                          leftValue: StatisticsManager.avarageVolumeBy(energyPrices: yearlyData).formatTwoSymbol,
                          leftValueType: MeasuringUnits.mWh.rawValue.localized,
                          rightTitle: "total_volume".localized,
                          rightValue: StatisticsManager.totalVolumeBy(energyPrices: yearlyData, measuringUnits: .tWh).formatTwoSymbol,
                          rightValueType: MeasuringUnits.tWh.rawValue.localized,
                          energyPrices: yearlyData),
            StatisticsRow(type: .ad)
        ]
        self.tableView.reloadData()
    }
}

extension HomeStatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.rows[indexPath.row]
        switch row.type {
        case .statistics:
            if let homeStatisticTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeStatisticTableViewCell", for: indexPath) as? HomeStatisticTableViewCell {
                ChartManager.setupStatisticLineChart(chartView: homeStatisticTableViewCell.chartView, energyPrices: row.energyPrices, statisticsType: row.statisticType)
                homeStatisticTableViewCell.titleLabel.text = row.statisticType.rawValue.localized
                homeStatisticTableViewCell.leftView.isHidden = row.leftViewIsHidden
                homeStatisticTableViewCell.leftLabel.text = row.leftTitle
                homeStatisticTableViewCell.leftValueLabel.text = row.leftValue
                homeStatisticTableViewCell.leftValueTypeLabel.text = row.leftValueType
                homeStatisticTableViewCell.rightView.isHidden = row.rightViewIsHidden
                homeStatisticTableViewCell.rightLabel.text = row.rightTitle
                homeStatisticTableViewCell.rightValueLabel.text = row.rightValue
                homeStatisticTableViewCell.rightTypeLabel.text = row.rightValueType
                
                return homeStatisticTableViewCell
            }
        case .ad:
            if let homeDashboardAdTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeDashboardAdTableViewCell", for: indexPath) as? HomeDashboardAdTableViewCell {
                homeDashboardAdTableViewCell.adBanner.adUnitID = AdsManager.adUnitID
                homeDashboardAdTableViewCell.adBanner.rootViewController = self
                homeDashboardAdTableViewCell.adBanner.load(GADRequest())
                return homeDashboardAdTableViewCell
            }
        }
        
        
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
    }
}

extension HomeStatisticsViewController {
    struct StatisticsRow {
        enum RowType {
            case statistics
            case ad
        }

        let type: RowType
        var statisticType: StatisticsType = .weeklyPrices
        var leftTitle: String = ""
        var leftValue: String = ""
        var leftValueType: String = ""
        var leftViewIsHidden:Bool = false
        var rightTitle: String = ""
        var rightValue: String = ""
        var rightValueType: String = ""
        var rightViewIsHidden:Bool = false
        var energyPrices: [EnergyPrice] = []
    }
}
