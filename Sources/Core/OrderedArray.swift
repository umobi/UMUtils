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

public struct OrderedArray<Element: Comparable>: Collection {
    public func index(after i: Int) -> Int {
        return i + 1
    }

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        self.lazyCount
    }

    private var array: [Element]
    private let mode: ComparisonResult

    private var lazyCount: Int = 0
    public init(_ mode: ComparisonResult) {
        self.mode = mode
        self.array = []
    }

    /// 1, 2, 3
    private func findLowerIndex(for element: Element) -> Index {
        var startIndex = 0
        var endIndex = self.lazyCount

        while startIndex < endIndex {
            let midIndex = startIndex + (endIndex - startIndex) / 2
            if array[midIndex] == element {
                return midIndex
            } else if array[midIndex] < element {
                startIndex = midIndex + 1
            } else {
                endIndex = midIndex
            }
        }

        return startIndex
    }

    /// 3, 2, 1
    private func findGratherIndex(for element: Element) -> Index {
        var startIndex = 0
        var endIndex = self.lazyCount

        while startIndex < endIndex {
            let midIndex = startIndex + (endIndex - startIndex) / 2
            if array[midIndex] == element {
                return midIndex
            } else if array[midIndex] > element {
                startIndex = midIndex + 1
            } else {
                endIndex = midIndex
            }
        }

        return startIndex
    }

    private func findIndex(for element: Element) -> Int {
        switch self.mode {
        case .orderedAscending, .orderedSame:
            return self.findLowerIndex(for: element)
        case .orderedDescending:
            return self.findGratherIndex(for: element)
        }
    }

    public func contains(_ element: Element) -> Bool {
        if self.array.isEmpty {
            return false
        }

        return self.array[self.findIndex(for: element)] == element
    }

    public mutating func append(_ element: Element) {
        self.array.insert(element, at: self.findIndex(for: element))
        self.lazyCount += 1
    }

    public mutating func removeIfContains(_ element: Element) {
        if self.array.isEmpty {
            return
        }

        guard self.array[self.findIndex(for: element)] == element else {
            return
        }

        self.remove(at: self.findIndex(for: element))
    }

    public mutating func remove(at index: Int) {
        self.array.remove(at: index)
        self.lazyCount -= 1
    }

    public subscript(_ index: Int) -> Element {
        self.array[index]
    }
}
