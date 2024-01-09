//
//  HomeDashboardViewController.swift
//  TokMarket
//
//  Created by KNG on 5.01.24.
//

import UIKit

class HomeDashboardViewController: UIViewController {
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var currentPriceValueLabel: UILabel!
    @IBOutlet weak var pricePerKWhLabel: UILabel!
    @IBOutlet weak var pricePerKWhValueLabel: UILabel!
    @IBOutlet weak var averagePriceLabel: UILabel!
    @IBOutlet weak var averagePricePerMWhLabel: UILabel!
    @IBOutlet weak var averagePricePerMWhValueLabel: UILabel!
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var minPriceValueLabel: UILabel!
    @IBOutlet weak var minPriceMWhLabel: UILabel!
    @IBOutlet weak var periodMinPriceLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet weak var maxPriceValueLabel: UILabel!
    @IBOutlet weak var maxPriceMWhLabel: UILabel!
    @IBOutlet weak var periodMaxPriceLabel: UILabel!
    
    var todayEnergyPrice: EnergyPrice?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.setObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        PriceManager.fetchEnergyPrices(completion: {error in
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.todayEnergyPrice = LocalDataManager.fetchEnergyPrice()
        setupScreen()
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        setupScreen()
    }
    
    func setupScreen() {
        guard let todayEnergyPrice = self.todayEnergyPrice else {
            return
        }
        
        self.currentPriceValueLabel.text = "\(LocalDataManager.getCurrentHourDataBy(energyPrice: todayEnergyPrice)?.bgn ?? 0.00) лв."
        self.pricePerKWhValueLabel.text = "\((LocalDataManager.getCurrentHourDataBy(energyPrice: todayEnergyPrice)?.bgn ?? 0.00) / 1000)"
        self.averagePricePerMWhValueLabel.text = "\(LocalDataManager.getAveragePriceTodayBy(energyPrice: todayEnergyPrice) ?? 0.00)"
        self.minPriceValueLabel.text = "\(LocalDataManager.getMinPriceTodayBy(energyPrice: todayEnergyPrice) ?? 0.00)"
        self.maxPriceValueLabel.text = "\(LocalDataManager.getMaxPriceTodayBy(energyPrice: todayEnergyPrice) ?? 0.00)"
    }
}

extension HomeDashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.todayEnergyPrice?.hourlyData.count ?? 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let priceInfo = self.todayEnergyPrice?.hourlyData[indexPath.row] else {
            return UITableViewCell()
        }
        if let homeDashboardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeDashboardTableViewCell", for: indexPath) as? HomeDashboardTableViewCell {
            homeDashboardTableViewCell.hourPeriodLabel.text = priceInfo.time
            homeDashboardTableViewCell.volumeValueLabel.text = "\(priceInfo.data?.volume ?? 0.0)"
            homeDashboardTableViewCell.priceValueLabel.text = "\(priceInfo.data?.bgn ?? 0.0)"
            return homeDashboardTableViewCell
        }
        return UITableViewCell()
    }
}
