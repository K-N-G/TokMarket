//
//  CustomStatisticsViewController.swift
//  TokMarket
//
//  Created by KNG on 8.02.24.
//

import UIKit
import DGCharts
import GoogleMobileAds

class CustomStatisticsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var periodSegment: UISegmentedControl!
    @IBOutlet weak var leftSlider: UISlider!
    @IBOutlet weak var rightSlider: UISlider!
    @IBOutlet weak var peakLabel: UILabel!
    @IBOutlet weak var offPeakLabel: UILabel!
    
    var sections: [CustomStatisticSection] = []
    var statisticTypePrice: StatisticsType = .weeklyPrices
    var statisticTypeVolume: StatisticsType = .weeklyVolume
    var leftSliderValue = 8
    var rightSliderValue = 20
    var periodData: [EnergyPrice] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        UserData.peakHours = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.periodSegment.setTitle("weekly".localized, forSegmentAt: 0)
        self.periodSegment.setTitle("monthly".localized, forSegmentAt: 1)
        self.periodSegment.setTitle("yearly".localized, forSegmentAt: 2)
        self.periodData = StatisticsManager.fetchWeeklyData()
        setupScreen()
    }
    
    @IBAction func changedSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.statisticTypePrice = .weeklyPrices
            self.statisticTypeVolume = .weeklyVolume
            self.periodData = StatisticsManager.fetchWeeklyData()
        case 1:
            self.statisticTypePrice = .monthlyPrices
            self.statisticTypeVolume = .monthlyVolume
            self.periodData = StatisticsManager.fetchMonthlyData()
        default:
            self.statisticTypePrice = .yearlyPrices
            self.statisticTypeVolume = .yearlyVolume
            self.periodData = StatisticsManager.fetchYearlyData()
        }
        setupScreen()
    }
    
    @IBAction func changedLeftSlider(_ sender: UISlider) {
        self.leftSliderValue = Int(sender.value)
        self.leftSlider.value = Float(self.leftSliderValue)
        setupScreen()
    }
    
    @IBAction func changedRightSlider(_ sender: UISlider) {
        self.rightSliderValue = Int(sender.value)
        self.rightSlider.value = Float(self.rightSliderValue)
        setupScreen()
    }
    
    func setPeakHours() {
        let startHour = self.leftSliderValue
        let endHour =  self.leftSliderValue < self.rightSliderValue ? self.rightSliderValue - 1 : self.rightSliderValue
        
        var peakHours: [String] = []
        
        for hour in startHour...endHour {
            let paddedHour = String(format: "%02d", Int(hour))
            peakHours.append("\(paddedHour):00:00")
        }
        UserData.peakHours = peakHours
    }
    
    func setupScreen() {
        setPeakHours()
        if self.leftSliderValue == 0 && self.rightSliderValue == 24 {
            self.peakLabel.text = "\("peak".localized): 0-24"
            self.offPeakLabel.text = "\("off_peak".localized):"
        } else if self.leftSliderValue == 12 && self.rightSliderValue == 12 {
            self.peakLabel.text = "\("peak".localized):"
            self.offPeakLabel.text = "\("off_peak".localized): 0-\(self.leftSliderValue) \(self.rightSliderValue)-24"
        } else if self.leftSliderValue == 0 {
            self.peakLabel.text = "\("peak".localized): \(self.leftSliderValue)-\(self.rightSliderValue - 1)"
            self.offPeakLabel.text = "\("off_peak".localized): \(self.rightSliderValue)-24"
        } else if self.rightSliderValue == 24 {
            self.peakLabel.text = "\("peak".localized): \(self.leftSliderValue)-\(self.rightSliderValue - 1)"
            self.offPeakLabel.text = "\("off_peak".localized): 0-\(self.leftSliderValue)"
        } else {
            self.peakLabel.text = "\("peak".localized): \(self.leftSliderValue)-\(self.rightSliderValue - 1)"
            self.offPeakLabel.text = "\("off_peak".localized): 0-\(self.leftSliderValue) \(self.rightSliderValue)-24"
        }
        self.sections = []
        if !(self.leftSliderValue == 12 && self.rightSliderValue == 12) {
            self.sections.append(setupCustomStatisticSection(sectionType: .peak, marketType: .peak))
        }
        if !(self.leftSliderValue == 0 && self.rightSliderValue == 24) {
            self.sections.append(setupCustomStatisticSection(sectionType: .offPeak, marketType: .offPeak))
        }
        self.tableView.reloadData()
    }
    
    func setupCustomStatisticSection(sectionType: SectionType, marketType: MarketType) -> CustomStatisticSection {
        var section = CustomStatisticSection(rows: [], type: sectionType)
        section.rows.append(CustomStatisticRow(type: .barChart, marketType: marketType, statisticsType: statisticTypePrice, energyPrices: periodData))
        section.rows.append(CustomStatisticRow(type: .statisticsInfo,
                                                leftTitle: "average_price".localized,
                                                leftValue: (StatisticsManager.avaragePriceBy(energyPrices: periodData, marketType: marketType) / 1000).formatTwoSymbol,
                                                leftValueType: MeasuringUnits.kWh.rawValue.localized,
                                                rightTitle: "average_price".localized,
                                                rightValue: StatisticsManager.avaragePriceBy(energyPrices: periodData, marketType: marketType).formatTwoSymbol,
                                                rightValueType: MeasuringUnits.mWh.rawValue.localized,
                                                energyPrices: periodData))
        section.rows.append(CustomStatisticRow(type: .statisticsInfo,
                                                leftTitle: "min_price".localized,
                                                leftValue: StatisticsManager.minPriceBy(energyPrices: periodData, marketType: marketType).formatTwoSymbol,
                                                leftValueType: MeasuringUnits.mWh.rawValue.localized,
                                                rightTitle: "max_price".localized,
                                                rightValue: StatisticsManager.maxPriceBy(energyPrices: periodData, marketType: marketType).formatTwoSymbol,
                                                rightValueType: MeasuringUnits.mWh.rawValue.localized,
                                                energyPrices: periodData))
        section.rows.append(CustomStatisticRow(type: .barChart, marketType: marketType, statisticsType: statisticTypeVolume, energyPrices: periodData))
        section.rows.append(CustomStatisticRow(type: .statisticsInfo,
                                                leftTitle: "average_volume".localized,
                                                leftValue: StatisticsManager.avarageVolumeBy(energyPrices: periodData, marketType: marketType).formatTwoSymbol,
                                                leftValueType: MeasuringUnits.mWh.rawValue.localized,
                                                rightTitle: "total_volume".localized,
                                                rightValue: StatisticsManager.totalVolumeBy(energyPrices: periodData, measuringUnits: .gWh, marketType: marketType).formatTwoSymbol,
                                                rightValueType: MeasuringUnits.gWh.rawValue.localized,
                                                energyPrices: periodData))
        section.rows.append(CustomStatisticRow(type: .statisticsInfo,
                                                leftTitle: "min_volume".localized,
                                                leftValue: StatisticsManager.minVolumeBy(energyPrices: periodData, marketType: marketType).formatTwoSymbol,
                                                leftValueType: MeasuringUnits.mWh.rawValue.localized,
                                                rightTitle: "max_volume".localized,
                                                rightValue: StatisticsManager.maxVolumeBy(energyPrices: periodData, marketType: marketType).formatTwoSymbol,
                                                rightValueType: MeasuringUnits.mWh.rawValue.localized,
                                                energyPrices: periodData))
        
        return section
    }
}

extension CustomStatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
                ChartManager.setupStatisticBarChart(barChartView: barChartTableViewCell.chartView, energyPrices: row.energyPrices, statisticsType: row.statisticsType, marketType: row.marketType)
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

extension CustomStatisticsViewController {
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
    
    struct CustomStatisticSection {
        var rows: [CustomStatisticRow]
        let type: SectionType

        var title: String {
            return type.description
        }
    }
    
    struct CustomStatisticRow {
        enum RowType {
            case statisticsInfo
            case linerChart
            case barChart
            case ad
        }

        let type: RowType
        var marketType: MarketType = .base
        var statisticsType: StatisticsType = .weeklyPrices
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
