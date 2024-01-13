//
//  HomeSettingsTitleSwitchTableViewCell.swift
//  TokMarket
//
//  Created by KNG on 13.01.24.
//

import UIKit

class HomeSettingsTitleSwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
