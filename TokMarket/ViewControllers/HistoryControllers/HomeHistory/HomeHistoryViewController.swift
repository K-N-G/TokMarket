//
//  HomeHistoryViewController.swift
//  TokMarket
//
//  Created by KNG on 5.01.24.
//

import UIKit
import GoogleMobileAds

class HomeHistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var rows: [HistoryRow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.setObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(updateScreen), name: .updateScreen, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        setupScreen()
    }
    
    @objc func updateScreen(notification: NSNotification) {
        setupScreen()
    }
    
    func setupScreen() {
        for energyPrice in LocalDataManager.fetchEnergyPrices() ?? [] {
            if self.rows.count % 5 == 0 && self.rows.count > 0 {
                self.rows.append(HistoryRow(energyPrice: nil, type: .ad))
                self.rows.append(HistoryRow(energyPrice: energyPrice, type: .history))
            } else {
                self.rows.append(HistoryRow(energyPrice: energyPrice, type: .history))
            }
        }
        self.tableView.reloadData()
    }
}

extension HomeHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.rows[indexPath.row]
        
        switch row.type {
        case .history:
            if let homeHistoryInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeHistoryInfoTableViewCell", for: indexPath) as? HomeHistoryInfoTableViewCell,
               let energyPrice = row.energyPrice {
                homeHistoryInfoTableViewCell.deyLabel.text = energyPrice.date
                homeHistoryInfoTableViewCell.avaregePriceLabel.text = "average_price".localized
                homeHistoryInfoTableViewCell.avaregePriceValueLabel.text = "\(CalculationManager.getAveragePriceTodayBy(energyPrice: energyPrice) ?? 0.00)"
                homeHistoryInfoTableViewCell.avaregePriceTypeLabel.text = " \(UserData.defaultCurrency.rawValue)/\(MeasuringUnits.mWh.rawValue)"
                homeHistoryInfoTableViewCell.totalVolumeLabel.text = "total_volume".localized
                homeHistoryInfoTableViewCell.totalVolumeValueLabel.text = "\(CalculationManager.getTotalVolumeBy(energyPrice: energyPrice) ?? 0.00)"
                homeHistoryInfoTableViewCell.totalVolumeTypeLabel.text = " \(MeasuringUnits.mWh.rawValue)"
                homeHistoryInfoTableViewCell.minPriceLabel.text = "min_price".localized
                homeHistoryInfoTableViewCell.minPriceValueLabel.text = "\(CalculationManager.getMinPriceTodayBy(energyPrice: energyPrice) ?? 0.00)"
                homeHistoryInfoTableViewCell.minPriceTypeLabel.text = " \(UserData.defaultCurrency.rawValue)/\(MeasuringUnits.mWh.rawValue)"
                homeHistoryInfoTableViewCell.maxPriceLabel.text = "max_price".localized
                homeHistoryInfoTableViewCell.maxPriceValueLabel.text = "\(CalculationManager.getMaxPriceTodayBy(energyPrice: energyPrice) ?? 0.00)"
                homeHistoryInfoTableViewCell.maxPriceTypeLabel.text = " \(UserData.defaultCurrency.rawValue)/\(MeasuringUnits.mWh.rawValue)"
                
                return homeHistoryInfoTableViewCell
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
        if let historyDetailsViewController = UIStoryboard.history.instantiateViewController(identifier: "HistoryDetailsViewController") as? HistoryDetailsViewController,
           let energyPrice = self.rows[indexPath.row].energyPrice {
            historyDetailsViewController.todayEnergyPrice = energyPrice
            self.navigationController?.pushViewController(historyDetailsViewController, animated: true)
        }
    }
}

extension HomeHistoryViewController {
    struct HistoryRow {
        enum RowType {
            case history
            case ad
        }
        
        let energyPrice: EnergyPrice?
        let type: RowType
    }
}
