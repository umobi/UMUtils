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
import Combine
import SwiftUI

public protocol MetaPageElement {
    associatedtype Index
    var indexPath: IndexPath { get }
    static func map(_ elements: [Index], startingAt indexPath: IndexPath) -> [Self]
}

@propertyWrapper @frozen
public struct Page<Element> where Element: MetaPageElement {
    @usableFromInline
    let items: CurrentValueSubject<[Element], Never>
    let page: CurrentValueSubject<MetaPage, Never>

    private let needsToLoadNextPage: PassthroughSubject<Void, Never>
    private let refreshPageRelay: PassthroughSubject<MetaPage, Never>

    public init(wrappedValue value: [Element]) {
        self.needsToLoadNextPage = .init()
        self.refreshPageRelay = .init()
        self.items = .init(value)
        self.page = .init(.empty)
    }

    @inline(__always) @inlinable
    public var wrappedValue: [Element] {
        get { self.items.value }
        set { self.items.value = newValue }
    }

    @inline(__always) @inlinable
    public var projectedValue: AnyPublisher<[Element], Never> {
        self.items.eraseToAnyPublisher()
    }

    @inline(__always)
    public func loadNextPage() {
        self.needsToLoadNextPage.send(())
    }
}

public extension Page {
    // MARK: Paged
    func appendRows(_ rows: [Element.Index], newPage: MetaPage, oldPage: MetaPage? = nil, map: ((Element) -> Element)? = nil) {
        let startIndex = newPage.startIndex - 1
        let appendRows = Element.map(rows, startingAt: .init(item: startIndex, section: 0)).map {
            map?($0) ?? $0
        }

        if case .reload? = oldPage?.status {
            let upperBound = startIndex+newPage.count
            self.items.value = Array(self.items.value[0..<startIndex]) +
                appendRows +
                {
                    if self.items.value.count > upperBound {
                        return Array(self.items.value[upperBound ..< self.items.value.count])
                    }

                    return []
                }()

            return
        }

        if newPage.currentPage == 0 || newPage.isFirst {
            self.items.value = appendRows
            self.page.value = newPage
            return
        }

        self.items.value += appendRows
        self.page.value = newPage
    }
}

public extension Page {
    var refreshPublisher: AnyPublisher<MetaPage, Never> {
        self.needsToLoadNextPage
            .flatMap { [weak page] _ -> AnyPublisher<MetaPage, Never> in
                guard
                    let value = page?.value,
                    case .next = value.status
                else {
                    return Empty()
                        .eraseToAnyPublisher()
                }
                
                page?.value = value.lock
                
                return Just(value)
                    .eraseToAnyPublisher()
            }
            .merge(with: refreshPageRelay)
            .eraseToAnyPublisher()
    }
}

public extension Page {
    func reloadPage(where item: Element) {
        let possiblePage = ((item.indexPath.item / self.page.value.count) + self.page.value.firstPage) - 1
        self.refreshPageRelay.send(self.page.value.reload(currentPage: possiblePage))
    }
}
