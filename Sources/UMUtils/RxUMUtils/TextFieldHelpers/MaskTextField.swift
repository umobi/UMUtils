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
import SwiftUI
import Combine

@propertyWrapper @frozen
public struct MaskedText: DynamicProperty {
    @Mutable private var relay: Relay
    private let mask: MaskType

    public init(wrappedValue value: String?, _ mask: MaskType) {
        self.mask = mask
        _relay = .init(wrappedValue: value.map { .string($0) } ?? .nil)
    }

    @inline(__always)
    public init(_ mask: MaskType) {
        self.init(wrappedValue: nil, mask)
    }

    public var wrappedValue: String? {
        get {
            switch relay {
            case .nil:
                return nil
            case .string(let string):
                return string
            }
        }
        nonmutating
        set {
            if let string = newValue?.mask(mask) {
                relay = .string(string)
            } else {
                relay = .nil
            }
        }
    }

    public var projectedValue: AnyPublisher<String?, Never> {
        _relay.publisher
            .map {
                switch $0 {
                case .nil:
                    return nil
                case .string(let string):
                    return string
                }
            }
            .eraseToAnyPublisher()
    }
}

private extension MaskedText {
    enum Relay {
        case `nil`
        case string(String)
    }
}
