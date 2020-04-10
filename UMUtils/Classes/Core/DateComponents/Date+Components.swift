//
//  Date+Components.swift
//  TokBeauty
//
//  Created by brennobemoura on 07/11/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import Foundation

public extension Date {
    struct Components {
        public let date: Date

        fileprivate init(_ date: Date) {
            self.date = date
        }

        public var weekday: Int {
            return Calendar.current.component(.weekday, from: self.date)
        }

        public var day: Int {
            return Calendar.current.component(.day, from: self.date)
        }

        public var month: Int {
            return Calendar.current.component(.month, from: self.date)
        }

        public var year: Int {
            return Calendar.current.component(.year, from: self.date)
        }

        public var hour: Int {
            return Calendar.current.component(.hour, from: self.date)
        }

        public var minute: Int {
            return Calendar.current.component(.minute, from: self.date)
        }

        public var second: Int {
            return Calendar.current.component(.second, from: self.date)
        }

        public var nanosecond: Int {
            return Calendar.current.component(.nanosecond, from: self.date)
        }

        public func edit(_ editing: (Components.Editable) -> Void) -> Components {
            let editable = Editable(self)
            editing(editable)
            return .init(self.date, editable)
        }

        private func value(_ component: Calendar.Component) -> Int {
            switch component {
            case .day:
                return self.day
            case .month:
                return self.month
            case .hour:
                return self.hour
            case .minute:
                return self.minute
            case .second:
                return self.second
            case .nanosecond:
                return self.nanosecond
            case .year:
                return self.year
            default:
                return 0
            }
        }

        private init(_ date: Date, _ editable: Components.Editable) {
            self.date = editable.array.reduce(date) {
                Calendar.current.date(byAdding: $1.0, value: $1.1 - date.components.value($1.0), to: $0)!
            }
        }
    }

    var components: Components {
        return .init(self)
    }
}

public extension Date.Components {
    class Editable {
        public var day: Int
        public var month: Int
        public var hour: Int
        public var minute: Int
        public var second: Int
        public var nanosecond: Int
        public var year: Int

        fileprivate init(_ components: Date.Components) {
            self.day = components.day
            self.month = components.month
            self.hour = components.hour
            self.minute = components.minute
            self.second = components.second
            self.nanosecond = components.nanosecond
            self.year = components.year
        }

        fileprivate var array: [(Calendar.Component, Int)] {
            return [
                (.day, self.day),
                (.month, self.month),
                (.hour, self.hour),
                (.minute, self.minute),
                (.second, self.second),
                (.nanosecond, self.nanosecond),
                (.year, self.year)
            ]
        }

        @discardableResult
        public func zeroTime(hour: Int = 0, minute: Int = 0, second: Int = 0, nanosecond: Int = 0) -> Self {
            self.hour = hour
            self.minute = minute
            self.second = second
            self.nanosecond = nanosecond
            return self
        }
    }
}
