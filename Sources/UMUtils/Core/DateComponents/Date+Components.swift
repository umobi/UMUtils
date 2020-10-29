//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

public extension Date {
    @frozen
    struct Components {
        public let date: Date
        
        fileprivate init(_ date: Date) {
            self.date = date
        }

        @inline(__always)
        public var weekday: Int {
            Calendar.current.component(.weekday, from: self.date)
        }

        @inline(__always)
        public var day: Int {
            Calendar.current.component(.day, from: self.date)
        }

        @inline(__always)
        public var month: Int {
            Calendar.current.component(.month, from: self.date)
        }

        @inline(__always)
        public var year: Int {
            Calendar.current.component(.year, from: self.date)
        }

        @inline(__always)
        public var hour: Int {
            Calendar.current.component(.hour, from: self.date)
        }

        @inline(__always)
        public var minute: Int {
            Calendar.current.component(.minute, from: self.date)
        }

        @inline(__always)
        public var second: Int {
            Calendar.current.component(.second, from: self.date)
        }

        @inline(__always)
        public var nanosecond: Int {
            Calendar.current.component(.nanosecond, from: self.date)
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

    @inline(__always)
    var components: Components {
        .init(self)
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
