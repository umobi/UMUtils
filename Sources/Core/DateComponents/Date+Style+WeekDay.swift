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
