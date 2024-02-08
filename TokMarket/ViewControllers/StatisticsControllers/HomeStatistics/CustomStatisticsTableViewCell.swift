//
//  CustomStatisticsTableViewCell.swift
//  TokMarket
//
//  Created by KNG on 8.02.24.
//

import UIKit
import DGCharts

class CustomStatisticsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
