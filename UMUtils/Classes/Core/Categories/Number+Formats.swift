//
//  Number+Formats.swift
//  SPAPartner
//
//  Created by Ramon Vicente on 03/09/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import Foundation

public extension Int {

    var humanTime: String {

        guard self >= 60 else {
            return "\(self)m"
        }

        guard self > 60 else {
            return "1h"
        }

        let hours = self/60
        let minutes = self%60
        return "\(hours)h \(minutes)m"
    }

    var time: String {
        guard self >= 60 else {
            return "00:\(String(format: "%02d", self))"
        }
        let hours = String(format: "%02d", self/60)
        let minutes = String(format: "%02d", self%60)
        return "\(hours):\(minutes)"
    }

}

public extension Double {
    var humanTime: String {
        return Int(self).humanTime
    }
}
