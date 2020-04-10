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

public extension Date.Style {

    struct Time {
        public enum Granularity {
            case hour(Int)
            case minute(Int)
        }

        private let granularity: Granularity

        fileprivate init(_ granularity: Granularity) {
            self.granularity = granularity
        }

        public var regular: String {
            switch self.granularity {
            case .hour(let hour):
                return String(format: "%02d", hour)
            case .minute(let minute):
                return String(format: "%02d", minute)
            }
        }

        public var short: String {
            switch self.granularity {
            case .hour(let hour):
                return "\(hour)"
            case .minute(let minute):
                return "\(minute)"
            }
        }
    }

    var hour: Time {
        return .init(.hour(self.date.components.hour))
    }

    var minute: Time {
        return .init(.minute(self.date.components.minute))
    }

}
