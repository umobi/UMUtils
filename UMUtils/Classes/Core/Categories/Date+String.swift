//
//  Date+String.swift
//  Umobi
//
//  Created by Ramon Vicente on 15/04/17.
//  Copyright © 2017 Umobi. All rights reserved.
//

import Foundation
private let dateFormatter = DateFormatter()

public extension Date {
    func string(format: String, locale: String = "en_US_POSIX") -> String {
        dateFormatter.locale = Locale(identifier: locale)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
