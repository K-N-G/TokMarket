//
//  Slider.swift
//  TokMarket
//
//  Created by KNG on 8.02.24.
//

import Foundation
import UIKit

class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 12))
    }
}
