//
//  Storyboard.swift
//  TokMarket
//
//  Created by KNG on 5.01.24.
//
import UIKit

extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard.init(name: "Main", bundle: nil)
    }
    
    static var dashboard: UIStoryboard {
        return UIStoryboard.init(name: "Dashboard", bundle: nil)
    }

    static var history: UIStoryboard {
        return UIStoryboard.init(name: "History", bundle: nil)
    }

    static var statistics: UIStoryboard {
        return UIStoryboard.init(name: "Statistics", bundle: nil)
    }

    static var settings: UIStoryboard {
        return UIStoryboard.init(name: "Settings", bundle: nil)
    }
}
