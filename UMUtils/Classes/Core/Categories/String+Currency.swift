//
//  String+Price.swift
//  SPAPartner
//
//  Created by Ramon Vicente on 03/09/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import Foundation

fileprivate let formatter = DateFormatter()

public extension String {
    var currency: Double {
        var amountWithPrefix = self

        let regex = (try? NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive))!
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix,
                                                          options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                          range: NSMakeRange(0, self.count),
                                                          withTemplate: "")
        let double = (digits as NSString).doubleValue
        return (double / 100)
    }

    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }

    var date: Date? {
        guard !self.isEmpty else { return nil }

        return formatter.date(from: self)
    }

    func asDate(fromFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        formatter.dateFormat = fromFormat
        return self.date
    }
}
