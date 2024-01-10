//
//  HomeHistoryViewController.swift
//  TokMarket
//
//  Created by KNG on 5.01.24.
//

import UIKit

class HomeHistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var energyPrices: [EnergyPrice] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.energyPrices = LocalDataManager.fetchEnergyPrices() ?? []
    }
}

extension HomeHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.energyPrices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let homeHistoryInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeHistoryInfoTableViewCell", for: indexPath) as? HomeHistoryInfoTableViewCell {
            let energyPrice = self.energyPrices[indexPath.row]
            homeHistoryInfoTableViewCell.deyLabel.text = energyPrice.date
            homeHistoryInfoTableViewCell.avaregePriceLabel.text = "Avarege price"
            homeHistoryInfoTableViewCell.avaregePriceValueLabel.text = "\(CalculationManager.getAveragePriceTodayBy(energyPrice: energyPrice) ?? 0.00)"
            homeHistoryInfoTableViewCell.avaregePriceTypeLabel.text = " \(UserData.defaultCurrency.rawValue)/\(MeasuringUnits.mWh.rawValue)"
            homeHistoryInfoTableViewCell.totalVolumeLabel.text = "Total volume"
            homeHistoryInfoTableViewCell.totalVolumeValueLabel.text = "\(CalculationManager.getTotalVolumeBy(energyPrice: energyPrice) ?? 0.00)"
            homeHistoryInfoTableViewCell.totalVolumeTypeLabel.text = " \(MeasuringUnits.mWh.rawValue)"
            homeHistoryInfoTableViewCell.minPriceLabel.text = "Min price"
            homeHistoryInfoTableViewCell.minPriceValueLabel.text = "\(CalculationManager.getMinPriceTodayBy(energyPrice: energyPrice) ?? 0.00)"
            homeHistoryInfoTableViewCell.minPriceTypeLabel.text = " \(UserData.defaultCurrency.rawValue)/\(MeasuringUnits.mWh.rawValue)"
            homeHistoryInfoTableViewCell.maxPriceLabel.text = "Max price"
            homeHistoryInfoTableViewCell.maxPriceValueLabel.text = "\(CalculationManager.getMaxPriceTodayBy(energyPrice: energyPrice) ?? 0.00)"
            homeHistoryInfoTableViewCell.maxPriceTypeLabel.text = " \(UserData.defaultCurrency.rawValue)/\(MeasuringUnits.mWh.rawValue)"
            
            return homeHistoryInfoTableViewCell
        }
        return UITableViewCell()
    }
    
    
}
