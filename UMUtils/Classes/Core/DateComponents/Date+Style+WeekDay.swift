//
//  Date+Style+WeekDay.swift
//  TokBeauty
//
//  Created by brennobemoura on 07/11/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import Foundation

extension Date.Style {
    struct WeekDay {
        private let date: Date

        fileprivate init(_ date: Date) {
            self.date = date
        }

        public var regular: String {
            let calendar = Calendar.current
            let dayIndex = (self.date.components.weekday - 1) % 7
            return calendar.weekdaySymbols[dayIndex]
        }

        public var short: String {
            let calendar = Calendar.current
            let dayIndex = (self.date.components.weekday - 1) % 7
            return calendar.shortWeekdaySymbols[dayIndex]
        }

        public var veryShort: String {
            let calendar = Calendar.current
            let dayIndex = (self.date.components.weekday - 1) % 7
            return calendar.veryShortWeekdaySymbols[dayIndex]
        }
    }

    var weekday: WeekDay {
        return .init(self.date)
    }
}
