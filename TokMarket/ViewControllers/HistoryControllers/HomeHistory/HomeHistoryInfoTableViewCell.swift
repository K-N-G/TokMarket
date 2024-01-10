//
//  HomeHistoryInfoTableViewCell.swift
//  TokMarket
//
//  Created by KNG on 10.01.24.
//

import UIKit

class HomeHistoryInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var deyLabel: UILabel!
    @IBOutlet weak var avaregePriceLabel: UILabel!
    @IBOutlet weak var avaregePriceValueLabel: UILabel!
    @IBOutlet weak var avaregePriceTypeLabel: UILabel!
    @IBOutlet weak var totalVolumeLabel: UILabel!
    @IBOutlet weak var totalVolumeValueLabel: UILabel!
    @IBOutlet weak var totalVolumeTypeLabel: UILabel!
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var minPriceValueLabel: UILabel!
    @IBOutlet weak var minPriceTypeLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet weak var maxPriceValueLabel: UILabel!
    @IBOutlet weak var maxPriceTypeLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
