//
//  HomeDashboardStatisticsTableViewCell.swift
//  TokMarket
//
//  Created by KNG on 9.01.24.
//

import UIKit

class HomeDashboardStatisticsTableViewCell: UITableViewCell {
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var leftValueLabel: UILabel!
    @IBOutlet weak var leftValueTypeLabel: UILabel!
    @IBOutlet weak var leftValueDescriptionLabel: UILabel!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightTitleLabel: UILabel!
    @IBOutlet weak var rightValueLabel: UILabel!
    @IBOutlet weak var rightValueTypeLabel: UILabel!
    @IBOutlet weak var rightDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
