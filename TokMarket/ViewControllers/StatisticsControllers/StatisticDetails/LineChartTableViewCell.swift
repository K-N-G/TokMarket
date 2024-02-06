//
//  LineChartTableViewCell.swift
//  TokMarket
//
//  Created by KNG on 1.02.24.
//

import UIKit
import DGCharts

class LineChartTableViewCell: UITableViewCell {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
