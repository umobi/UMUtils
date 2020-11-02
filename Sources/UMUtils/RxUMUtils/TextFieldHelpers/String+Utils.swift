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

@frozen
indirect public enum MaskType {
    case raw(String)
    case numeric(String)
    case or(MaskType, MaskType)

    var mask: String? {
        switch self {
        case .raw(let mask):
            return mask
        case .numeric(let mask):
            return mask
        default:
            return nil
        }
    }
}

public extension String {
    private func applyMask(_ mask: String) -> (String, isValid: Bool) {
        var string = self
        mask.enumerated()
            .filter { $0.element != "#" }
            .forEach { mask in
                guard let beforeIndex = string.index(string.endIndex, offsetBy: -1, limitedBy: string.startIndex) else {
                     return
                }

                if let index = string.index(string.startIndex, offsetBy: mask.offset, limitedBy: beforeIndex) {
                    if let char = string.enumerated().first(where: {$0.offset == mask.offset}), char.element == mask.element {
                        return
                    }
                    string.insert(mask.element, at: index)
                }
        }

        return (String(string.prefix(mask.count)), string.count <= mask.count)
    }

    @discardableResult
    func applyMask(_ maskType: MaskType) -> (String, isValid: Bool) {
        switch maskType {
        case .raw(let mask):
            return self.applyMask(mask)
        case .numeric(let mask):
            return self.components(separatedBy: CharacterSet.decimalDigits.inverted)
                .joined()
                .applyMask(mask)
        case .or(let left, let right):
            let leftMasked = self.applyMask(left)
            if !leftMasked.1 {
                return self.applyMask(right)
            }

            return leftMasked
        }
    }

    @inline(__always)
    func mask(_ mask: MaskType) -> String {
        self.applyMask(mask).0
    }
}
