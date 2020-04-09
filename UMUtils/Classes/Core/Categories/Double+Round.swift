//
//  Double+Round.swift
//  SPA at home
//
//  Created by Ramon Vicente on 15/04/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import Foundation

public extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    var rounded: Double {
        return self.roundTo(places: 1)
    }
}
