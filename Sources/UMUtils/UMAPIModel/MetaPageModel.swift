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
import UICreator
import RxSwift
import RxCocoa

public protocol MetaPageElement {
    associatedtype Index
    var indexPath: IndexPath { get }
    static func map(_ elements: [Index], startingAt indexPath: IndexPath) -> [Self]
}

@propertyWrapper
public struct Page<Element> where Element: MetaPageElement {
    @Value private var items: [Element]
    @Value private var page: MetaPage

    private let needsToLoadNextPage: PublishRelay<Void>
    private let refreshPageRelay: PublishRelay<MetaPage>

    public init(wrappedValue value: [Element]) {
        self.needsToLoadNextPage = .init()
        self.refreshPageRelay = .init()
        self._items = .init(wrappedValue: value)
        self._page = .init(wrappedValue: .empty)
    }

    public var wrappedValue: [Element] {
        get { self.items }
        set { self.items = newValue }
    }

    public var projectedValue: Relay<[Element]> {
        self.$items
    }

    public func loadNextPage() {
        self.needsToLoadNextPage.accept(())
    }
}

public extension Page {
    // MARK: Paged
    func appendRows(_ rows: [Element.Index], newPage: MetaPage, oldPage: MetaPage? = nil, map: ((Element) -> Element)? = nil) {
        let startIndex = newPage.startIndex - 1
        let appendRows = Element.map(rows, startingAt: .init(row: startIndex, section: 0)).map {
            map?($0) ?? $0
        }

        if case .reload? = oldPage?.status {
            let upperBound = startIndex+newPage.count
            self.items = Array(self.items[0..<startIndex]) +
                appendRows +
                {
                    if self.items.count > upperBound {
                        return Array(self.items[upperBound ..< self.items.count])
                    }

                    return []
                }()

            return
        }

        if newPage.currentPage == 0 || newPage.isFirst {
            self.items = appendRows
            self.page = newPage
            return
        }

        self.items += appendRows
        self.page = newPage
    }
}

public extension Page {
    var refreshObservable: Observable<MetaPage> {
        let page = self.$page

        return .merge(
            self.refreshPageRelay
                .asObservable(),
            self.needsToLoadNextPage
                .asObservable()
                .map { page.wrappedValue }
                .filter { $0.status == .next }
                .do(onNext: {
                    page.wrappedValue = $0.lock
                })
        )
    }
}

public extension Page {
    func reloadPage(where item: Element) {
        let possiblePage = ((item.indexPath.row / self.page.count) + self.page.firstPage) - 1
        self.refreshPageRelay.accept(self.page.reload(currentPage: possiblePage))
    }
}
