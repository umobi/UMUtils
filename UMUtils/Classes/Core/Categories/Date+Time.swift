//
//  Date+Time.swift
//  SPAPartner
//
//  Created by Ramon Vicente on 02/09/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import Foundation

public extension Date {
    init(time: String) {
        let hour = Int(time.components(separatedBy: ":")[0])
        let minute = Int(time.components(separatedBy: ":")[1])
        self = Date(hour: hour, minute: minute) ?? Date()
    }

    init?(timeZone: TimeZone? = nil, year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) {
        let calendar = Calendar.current
        let components = DateComponents(timeZone: timeZone, year: year, month: month, day: day, hour: hour, minute: minute, second: second)

        guard let date = calendar.date(from: components) else { return nil }
            self = date
    }
}
