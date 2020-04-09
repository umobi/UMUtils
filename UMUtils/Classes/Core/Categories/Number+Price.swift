//
//  Number+Price.swift
//  SPA at home
//
//  Created by Ramon Vicente on 11/04/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import Foundation

public extension NSNumber {

    var priceString: String {
        let numberFormatter = NumberFormatter()
        if #available(iOS 9.0, *) {
            numberFormatter.numberStyle = .currencyAccounting
        } else {
            numberFormatter.numberStyle = .currency
        }
        numberFormatter.locale = Locale(identifier: "pt_BR")
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        let absSelf = NSNumber(value: abs(self.doubleValue))
        let formatted = numberFormatter.string(from: absSelf) ?? ""
        return self.doubleValue >= 0 ? formatted : "- " + formatted
    }
}

public extension Double {
    var priceString: String {
        return (self as NSNumber).priceString
    }
}

public extension Float {
    var priceString: String {
        return (self as NSNumber).priceString
    }
}

public extension Int {
    var priceString: String {
        return (self as NSNumber).priceString
    }
}
