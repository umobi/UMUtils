//
//  Date+Style+Month.swift
//  TokBeauty
//
//  Created by brennobemoura on 07/11/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import Foundation

public extension Date.Style {
    public struct Month {
        private let date: Date

        fileprivate init(_ date: Date) {
            self.date = date
        }

        public var regular: String {
            let calendar = Calendar.current
            let monthIndex = (self.date.components.month - 1) % 12
            return calendar.monthSymbols[monthIndex]
        }

        public var short: String {
            let calendar = Calendar.current
            let monthIndex = (self.date.components.month - 1) % 12
            return calendar.shortMonthSymbols[monthIndex]
        }

        public var veryShort: String {
            let calendar = Calendar.current
            let monthIndex = (self.date.components.month - 1) % 12
            return calendar.veryShortMonthSymbols[monthIndex]
        }
    }

    public var month: Month {
        return .init(self.date)
    }
}
