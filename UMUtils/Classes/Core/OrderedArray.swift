//
//  OrderedArray.swift
//  TokBeauty
//
//  Created by brennobemoura on 14/03/20.
//  Copyright © 2020 TokBeauty. All rights reserved.
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
