//
//  HomeDashboardTableViewCell.swift
//  TokMarket
//
//  Created by KNG on 8.01.24.
//

import UIKit

class HomeDashboardTableViewCell: UITableViewCell {
    @IBOutlet weak var hourPeriodLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var volumeValueLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
