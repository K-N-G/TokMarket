//
//  BarChartTableViewCell.swift
//  TokMarket
//
//  Created by KNG on 1.02.24.
//

import UIKit
import DGCharts

class BarChartTableViewCell: UITableViewCell {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var chartView: BarChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        chartView.delegate = self
    }
}

extension BarChartTableViewCell: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        self.valueLabel.text = "\(entry.y)"
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        self.valueLabel.text = " "
        chartView.highlightValue(nil, callDelegate: false)
    }
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        self.valueLabel.text = " "
        chartView.highlightValue(nil, callDelegate: false)
    }
}
