//
//  HomeDashboardViewController.swift
//  TokMarket
//
//  Created by KNG on 5.01.24.
//

import UIKit
import DGCharts

class HomeDashboardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentDateTimeLabel: UILabel!
    @IBOutlet weak var currentPriceValueLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    
    var todayEnergyPrice: EnergyPrice?
    var rows: [DashboardRow] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.delegate = self
        NotificationCenter.default.setObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(updateScreen), name: .updateScreen, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.todayEnergyPrice = LocalDataManager.fetchEnergyPrice()
        setupScreen()
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        setupScreen()
    }
    
    @objc func updateScreen(notification: NSNotification) {
        setupScreen()
    }
    
    
    func setupScreen() {
        guard let todayEnergyPrice = self.todayEnergyPrice,
        let hourlyData = LocalDataManager.getCurrentHourDataBy(energyPrice: todayEnergyPrice) else {
            return
        }
        ChartManager.setupLineChart(chartView: chartView, energyPrice: todayEnergyPrice)
        self.rows = []
        self.currentDateTimeLabel.text = "\(LocalDataManager.getCurrentDate())  \(CalculationManager.getPeriodBy(time: LocalDataManager.getCurrentHour()))"
        self.currentPriceValueLabel.text = "\(LocalDataManager.getPriceBy(hourlyData: hourlyData) ?? 0.00) \(UserData.defaultCurrency.rawValue)"
        self.rows = [
            DashboardRow(titleName: "", 
                         type: .statistics,
                         leftTitle: "\("price_per".localized) \(MeasuringUnits.kWh.rawValue)",
                         leftValue: "\(((LocalDataManager.getPriceBy(hourlyData: hourlyData) ?? 0.00) / 1000).formatFiveSymbol)",
                         leftValueType: " \(UserData.defaultCurrency.rawValue)/\(MeasuringUnits.kWh.rawValue)",
                         leftdescriptionIsVisible: true,
                         rightTitle: "average_price".localized,
                         rightValue: "\(CalculationManager.getAveragePriceTodayBy(energyPrice: todayEnergyPrice) ?? 0.00)",
                         rightValueType: " \(UserData.defaultCurrency.rawValue)/\(MeasuringUnits.mWh.rawValue)",
                         rightdescriptionIsVisible: true),
            DashboardRow(titleName: "",
                         type: .statistics,
                         leftTitle: "off_peak_market".localized,
                         leftValue: "\(CalculationManager.getAveragePriceOffPeakBy(energyPrice: todayEnergyPrice) ?? 0.00)",
                         leftValueType: " \(UserData.defaultCurrency.rawValue)/\(MeasuringUnits.mWh.rawValue)",
                         leftdescriptionIsVisible: true,
                         rightTitle: "peak_market".localized,
                         rightValue: "\(CalculationManager.getAveragePricePeakBy(energyPrice: todayEnergyPrice) ?? 0.00)",
                         rightValueType: " \(UserData.defaultCurrency.rawValue)/\(MeasuringUnits.mWh.rawValue)",
                         rightdescriptionIsVisible: true),
            DashboardRow(titleName: "",
                         type: .statistics,
                         leftTitle: "min_price".localized,
                         leftValue: "\(CalculationManager.getMinPriceTodayBy(energyPrice: todayEnergyPrice) ?? 0.00)",
                         leftValueType: " \(UserData.defaultCurrency.rawValue)/\(MeasuringUnits.mWh.rawValue)",
                         leftDescription: "\("period".localized): \(CalculationManager.getPeriodBy(time: CalculationManager.getMinHourlyDataBy(energyPrice: todayEnergyPrice)?.time ?? ""))",
                         rightTitle: "max_price".localized,
                         rightValue: "\(CalculationManager.getMaxPriceTodayBy(energyPrice: todayEnergyPrice) ?? 0.00)",
                         rightValueType: " \(UserData.defaultCurrency.rawValue)/\(MeasuringUnits.mWh.rawValue)",
                         rightDescription: "\("period".localized): \(CalculationManager.getPeriodBy(time: CalculationManager.getMaxHourlyDataBy(energyPrice: todayEnergyPrice)?.time ?? ""))"),
            DashboardRow(titleName: "",
                         type: .statistics,
                         leftTitle: "total_volume".localized,
                         leftValue: "\(CalculationManager.getTotalVolumeBy(energyPrice: todayEnergyPrice) ?? 0.00)",
                         leftValueType: " \(MeasuringUnits.mWh.rawValue)",
                         leftdescriptionIsVisible: false,
                         rightTitle: "volume".localized,
                         rightValue: "\(LocalDataManager.getCurrentHourInfoBy(energyPrice: todayEnergyPrice)?.volume ?? 0.00)",
                         rightValueType: " \(MeasuringUnits.mWh.rawValue)",
                         rightdescriptionIsVisible: false),
            DashboardRow(titleName: "ad_banner".localized, type: .ad)
            
        ]
        if let hourlyDatas = self.todayEnergyPrice?.hourlyData {
            var hourlyDataCount = 0
            for hourlyData in hourlyDatas {
                if let hourlyInfo = hourlyData.data {
                    self.rows.append(DashboardRow(titleName: hourlyData.time, type: .hourInfo, hourlyInfo: hourlyInfo))
                    hourlyDataCount += 1
                    if hourlyDataCount == 8 || hourlyDataCount == 21 {
                        self.rows.append(DashboardRow(titleName: "ad_banner".localized, type: .ad))
                    }
                }
            }
            self.rows.append(DashboardRow(titleName: "ad_banner".localized, type: .ad))
        }
        
        self.tableView.reloadData()
    }
}

extension HomeDashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.rows[indexPath.row]
        
        switch rows[indexPath.row].type {
        case .statistics:
            if let homeDashboardStatisticsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeDashboardStatisticsTableViewCell", for: indexPath) as? HomeDashboardStatisticsTableViewCell {
                homeDashboardStatisticsTableViewCell.leftView.isHidden = row.leftViewIsVisible
                homeDashboardStatisticsTableViewCell.leftTitleLabel.text = row.leftTitle
                homeDashboardStatisticsTableViewCell.leftValueLabel.text = row.leftValue
                homeDashboardStatisticsTableViewCell.leftValueTypeLabel.text = row.leftValueType
                homeDashboardStatisticsTableViewCell.leftValueDescriptionLabel.isHidden = row.leftdescriptionIsVisible
                homeDashboardStatisticsTableViewCell.leftValueDescriptionLabel.text = row.leftDescription
                homeDashboardStatisticsTableViewCell.rightView.isHidden = row.rightViewIsVisible
                homeDashboardStatisticsTableViewCell.rightTitleLabel.text = row.rightTitle
                homeDashboardStatisticsTableViewCell.rightValueLabel.text = row.rightValue
                homeDashboardStatisticsTableViewCell.rightValueTypeLabel.text = row.rightValueType
                homeDashboardStatisticsTableViewCell.rightDescriptionLabel.isHidden = row.rightdescriptionIsVisible
                homeDashboardStatisticsTableViewCell.rightDescriptionLabel.text = row.rightDescription
                return homeDashboardStatisticsTableViewCell
            }
        case .hourInfo:
            if let homeDashboardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeDashboardTableViewCell", for: indexPath) as? HomeDashboardTableViewCell {
                homeDashboardTableViewCell.hourPeriodLabel.text = "\("period".localized): \(CalculationManager.getPeriodBy(time: row.titleName))"
                homeDashboardTableViewCell.volumeLabel.text = "\("volume".localized) \(MeasuringUnits.mWh.rawValue)"
                homeDashboardTableViewCell.volumeValueLabel.text = "\(row.hourlyInfo?.volume ?? 0.0)"
                homeDashboardTableViewCell.priceLabel.text = "\("price".localized) \(MeasuringUnits.mWh.rawValue)"
                homeDashboardTableViewCell.priceValueLabel.text = "\(LocalDataManager.getPriceBy(hourlyInfo: row.hourlyInfo) ?? 0.0)"
                if row.titleName == LocalDataManager.getCurrentHour() {
                    homeDashboardTableViewCell.cellView.backgroundColor = UIColor(named: "currentCell")
                    UserData.currentDashboardHour = row.titleName
                } else {
                    homeDashboardTableViewCell.cellView.backgroundColor = UIColor(named: "xWhite")
                }
                return homeDashboardTableViewCell
            }
        case .ad:
            if let homeDashboardAdTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeDashboardAdTableViewCell", for: indexPath) as? HomeDashboardAdTableViewCell {
                homeDashboardAdTableViewCell.adTitleLabel.text = row.titleName
                return homeDashboardAdTableViewCell
            }
            break
        }
        return UITableViewCell()
    }
}

extension HomeDashboardViewController {
    struct DashboardRow {
        enum RowType {
            case statistics
            case hourInfo
            case ad
        }

        let titleName: String
        let type: RowType
        var leftTitle: String = ""
        var leftValue: String = ""
        var leftValueType: String = ""
        var leftDescription: String = ""
        var leftdescriptionIsVisible:Bool = false
        var leftViewIsVisible:Bool = false
        var rightTitle: String = ""
        var rightValue: String = ""
        var rightValueType: String = ""
        var rightDescription: String = ""
        var rightdescriptionIsVisible:Bool = false
        var rightViewIsVisible:Bool = false
        var hourlyInfo: HourlyInfo?
    }
}

extension HomeDashboardViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        self.currentDateTimeLabel.text = "\(LocalDataManager.getCurrentDate()) \(CalculationManager.getPeriodBy(time: "\(Int(entry.x))"))"
        self.currentPriceValueLabel.text = "\(entry.y) \(UserData.defaultCurrency.rawValue)"
        
    }
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        chartView.highlightPerTapEnabled = false
        chartView.highlightValue(nil, callDelegate: false)
        self.setupScreen()
    }
}
