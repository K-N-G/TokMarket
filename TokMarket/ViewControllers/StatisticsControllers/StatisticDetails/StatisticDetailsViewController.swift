//
//  StatisticDetailsViewController.swift
//  TokMarket
//
//  Created by KNG on 1.02.24.
//

import UIKit
import GoogleMobileAds


class StatisticDetailsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var sections: [StatisticDetailsSection] = []
    var statisticType: StatisticsType = .weeklyPrices

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = statisticType.rawValue.localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
    }
    
    func setupScreen() {
        self.sections = [
            setupStatisticSection(sectionType: .peak),
            setupStatisticSection(sectionType: .offPeak),
            setupStatisticSection(sectionType: .base)
        ]
    }
    
    func setupStatisticSection(sectionType: SectionType) -> StatisticDetailsSection {
        let valueIsPriceType: Bool = {
            switch self.statisticType {
            case .monthlyPrices, .weeklyPrices, .yearlyPrices:
                return true
            default:
                return false
            }
        }()
        
        let periodData = {
            switch self.statisticType {
            case .weeklyPrices, .weeklyVolume:
                return StatisticsManager.fetchWeeklyData()
            case .monthlyPrices, .monthlyVolume:
                return StatisticsManager.fetchMonthlyData()
            case .yearlyPrices, .yearlyVolume:
                return StatisticsManager.fetchYearlyData()
            }
        }()
        
        let marketType: MarketType = {
            switch sectionType {
            case .base:
                return .base
            case .peak:
                return .peak
            case .offPeak:
                return .offPeak
            }
        }()
        
        var section = StatisticDetailsSection(rows: [], type: sectionType)
        section.rows.append(StatisticDetailsRow(type: .barChart, marketType: marketType, energyPrices: periodData))
        
        if valueIsPriceType {
            section.rows.append(StatisticDetailsRow(type: .statisticsInfo,
                                                    leftTitle: "average_price".localized,
                                                    leftValue: (StatisticsManager.avaragePriceBy(energyPrices: periodData, marketType: marketType) / 1000).formatTwoSymbol,
                                                    leftValueType: MeasuringUnits.kWh.rawValue.localized,
                                                    rightTitle: "average_price".localized,
                                                    rightValue: StatisticsManager.avaragePriceBy(energyPrices: periodData, marketType: marketType).formatTwoSymbol,
                                                    rightValueType: MeasuringUnits.mWh.rawValue.localized,
                                                    energyPrices: periodData))
            section.rows.append(StatisticDetailsRow(type: .statisticsInfo,
                                                    leftTitle: "min_price".localized,
                                                    leftValue: StatisticsManager.minPriceBy(energyPrices: periodData, marketType: marketType).formatTwoSymbol,
                                                    leftValueType: MeasuringUnits.mWh.rawValue.localized,
                                                    rightTitle: "max_price".localized,
                                                    rightValue: StatisticsManager.maxPriceBy(energyPrices: periodData, marketType: marketType).formatTwoSymbol,
                                                    rightValueType: MeasuringUnits.mWh.rawValue.localized,
                                                    energyPrices: periodData))
        } else {
            section.rows.append(StatisticDetailsRow(type: .statisticsInfo,
                                                    leftTitle: "average_volume".localized,
                                                    leftValue: StatisticsManager.avarageVolumeBy(energyPrices: periodData, marketType: marketType).formatTwoSymbol,
                                                    leftValueType: MeasuringUnits.mWh.rawValue.localized,
                                                    rightTitle: "total_volume".localized,
                                                    rightValue: StatisticsManager.totalVolumeBy(energyPrices: periodData, measuringUnits: .gWh, marketType: marketType).formatTwoSymbol,
                                                    rightValueType: MeasuringUnits.gWh.rawValue.localized,
                                                    energyPrices: periodData))
            section.rows.append(StatisticDetailsRow(type: .statisticsInfo,
                                                    leftTitle: "min_volume".localized,
                                                    leftValue: StatisticsManager.minVolumeBy(energyPrices: periodData, marketType: marketType).formatTwoSymbol,
                                                    leftValueType: MeasuringUnits.mWh.rawValue.localized,
                                                    rightTitle: "max_volume".localized,
                                                    rightValue: StatisticsManager.maxVolumeBy(energyPrices: periodData, marketType: marketType).formatTwoSymbol,
                                                    rightValueType: MeasuringUnits.mWh.rawValue.localized,
                                                    energyPrices: periodData))
            
        }
        return section
    }
}

extension StatisticDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = .xWhite
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        label.text = self.sections[section].title
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textColor = .xdarkGray
        label.backgroundColor = .clear

        headerView.addSubview(label)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.sections[indexPath.section].rows[indexPath.row]
        
        switch row.type {
        case .statisticsInfo:
            if let statisticDetailsInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StatisticDetailsInfoTableViewCell", for: indexPath) as? StatisticDetailsInfoTableViewCell {
                statisticDetailsInfoTableViewCell.leftView.isHidden = row.leftViewisHidden
                statisticDetailsInfoTableViewCell.leftTitleLabel.text = row.leftTitle
                statisticDetailsInfoTableViewCell.leftValueLabel.text = row.leftValue
                statisticDetailsInfoTableViewCell.leftValueTypeLabel.text = row.leftValueType
                statisticDetailsInfoTableViewCell.rightView.isHidden = row.rightViewisHidden
                statisticDetailsInfoTableViewCell.rightTitleLabel.text = row.rightTitle
                statisticDetailsInfoTableViewCell.rightValueLabel.text = row.rightValue
                statisticDetailsInfoTableViewCell.rightValueTypeLabel.text = row.rightValueType
                return statisticDetailsInfoTableViewCell
            }
        case .linerChart:
            if let lineChartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LineChartTableViewCell", for: indexPath) as? LineChartTableViewCell {
                ChartManager.setupLineChart(chartView: lineChartTableViewCell.chartView, energyPrice: row.energyPrices.first!)
                return lineChartTableViewCell
            }
        case .barChart:
            if let barChartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BarChartTableViewCell", for: indexPath) as? BarChartTableViewCell {
                ChartManager.setupStatisticBarChart(barChartView: barChartTableViewCell.chartView, energyPrices: row.energyPrices, statisticsType: self.statisticType, marketType: row.marketType)
                barChartTableViewCell.chartView.delegate?.chartValueNothingSelected?(barChartTableViewCell.chartView)
                return barChartTableViewCell
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
}

extension StatisticDetailsViewController {
    enum SectionType: String {
        case base
        case peak
        case offPeak
    
        var description: String {
            switch self {
            case .base:
                return "base_market".localized
            case .peak:
                return "peak_market".localized
            case .offPeak:
                return "off_peak_market".localized
            }
        }
    }
    
    struct StatisticDetailsSection {
        

        var rows: [StatisticDetailsRow]
        let type: SectionType

        var title: String {
            return type.description
        }
    }
    
    struct StatisticDetailsRow {
        enum RowType {
            case statisticsInfo
            case linerChart
            case barChart
            case ad
        }

        let type: RowType
        var marketType: MarketType = .base
        var leftTitle: String = ""
        var leftValue: String = ""
        var leftValueType: String = ""
        var leftViewisHidden:Bool = false
        var rightTitle: String = ""
        var rightValue: String = ""
        var rightValueType: String = ""
        var rightViewisHidden:Bool = false
        var energyPrices: [EnergyPrice] = []
    }
}


