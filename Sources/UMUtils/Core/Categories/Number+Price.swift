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

public extension NSNumber {

    @inlinable
    var priceString: String {
        let numberFormatter = NumberFormatter()
        if #available(iOS 9.0, *) {
            numberFormatter.numberStyle = .currencyAccounting
        } else {
            numberFormatter.numberStyle = .currency
        }
        numberFormatter.locale = Locale(identifier: "pt_BR")
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        let absSelf = NSNumber(value: abs(self.doubleValue))
        let formatted = numberFormatter.string(from: absSelf) ?? ""
        return self.doubleValue >= 0 ? formatted : "- " + formatted
    }
}

public extension Double {
    @inlinable
    var priceString: String {
        (self as NSNumber).priceString
    }
}

public extension Float {
    @inlinable
    var priceString: String {
        (self as NSNumber).priceString
    }
}

public extension Int {
    @inlinable
    var priceString: String {
        (self as NSNumber).priceString
    }
}
