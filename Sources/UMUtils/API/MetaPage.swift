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
public enum MetaPageStatus {
    case empty
    case end
    case next
    case lock
    case reload
}

@frozen
public struct MetaPage: Codable {
    public let currentPage: Int
    public let startIndex: Int
    public let lastPage: Int
    public let count: Int
    public let total: Int
    public let status: MetaPageStatus
    public let firstPage: Int

    @inlinable
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.currentPage = try container.decode(.currentPage)
        self.startIndex = try container.decode(.startIndex)
        self.lastPage = try container.decode(.lastPage)
        self.count = try container.decode(.count)
        self.total = try container.decode(.total)
        self.firstPage = 1

        if currentPage == lastPage {
            self.status = .end
        } else {
            self.status = .next
        }

    }

    private init() {
        self.currentPage = 0
        self.startIndex = 0
        self.lastPage = 0
        self.count = 0
        self.total = 0
        self.firstPage = 0
        self.status = .empty
    }

    @inline(__always)
    public static var empty: MetaPage {
        .init()
    }

    public var lock: MetaPage {
        self.edit {
            $0.status = .lock
        }
    }

    public var isEmpty: Bool {
        self.status == .empty
    }

    public var isLocked: Bool {
        self.status == .lock
    }

    public var isFirst: Bool {
        self.currentPage == self.firstPage
    }

    public var nextPage: Int {
        self.isEmpty ? 1 : self.currentPage + 1
    }

    private init(original: MetaPage, editable: Editable) {
        self.currentPage = editable.currentPage
        self.firstPage = original.firstPage
        self.lastPage = original.lastPage
        self.count = original.count
        self.status = editable.status
        self.total = original.total
        self.startIndex = editable.currentPage * original.count
    }

    @inline(__always) @usableFromInline
    func edit(_ editing: (Editable) -> Void) -> MetaPage {
        let editable = Editable(currentPage: self.currentPage, status: self.status)
        editing(editable)
        return .init(original: self, editable: editable)
    }

    @inlinable
    public func reload(currentPage: Int) -> MetaPage {
        self.edit {
            $0.currentPage = currentPage
            $0.status = .reload
        }
    }
}

public extension MetaPage {
    class Editable {
        @usableFromInline
        var currentPage: Int

        @usableFromInline
        var status: MetaPageStatus

        internal init(currentPage: Int, status: MetaPageStatus) {
            self.currentPage = currentPage
            self.status = status
        }
    }
}

public extension MetaPage {
    @frozen
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case startIndex = "from"
        case lastPage = "last_page"
        case count = "per_page"
        case total = "total"
    }
}
