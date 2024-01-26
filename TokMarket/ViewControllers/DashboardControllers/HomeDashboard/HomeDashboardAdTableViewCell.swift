//
//  HomeDashboardAdTableViewCell.swift
//  TokMarket
//
//  Created by KNG on 9.01.24.
//

import UIKit
import GoogleMobileAds

class HomeDashboardAdTableViewCell: UITableViewCell {
    @IBOutlet weak var adBanner: GADBannerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
