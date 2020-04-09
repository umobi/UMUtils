//
//  String+Localized.swift
//  SPA at home
//
//  Created by Ramon Vicente on 14/03/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import Foundation

public extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }

    var initials: String {
        return self.components(separatedBy: " ")
            .reduce("") {
                let first = $0.first ?? Character(" ")
                let second = $1.first ?? Character(" ")
                return ($0 == "" ? "" : "\(first)") + "\(second)" }
    }

    func removingRegexMatches(pattern: String, replaceWith: String = "") -> String? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch {
            return nil
        }
    }
}
