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

@inline(__always) @inlinable
public func positiveOrZero<Number>(_ x: Number) -> Number where Number: Numeric & Comparable {
    x <= 0 ? 0 : x
}

@frozen
public struct ActivityPublisher: Publisher {
    public typealias Output = Bool
    public typealias Failure = Never

    private let subject = CurrentValueSubject<Int, Never>(0)

    @inlinable
    public init() {}

    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        subscriber.receive(subscription: Subscription(subscriber, self.subject))
    }

    @inline(__always)
    func increment() {
        self.subject.value += 1
    }

    @inline(__always)
    func decrement() {
        self.subject.value = positiveOrZero(self.subject.value - 1)
    }
}

extension ActivityPublisher {
    class Subscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == Bool, SubscriberType.Failure == Never {

        private(set) var subscriber: SubscriberType?
        private var cancellations: [AnyCancellable] = []

        init(_ subscriber: SubscriberType,_ value: CurrentValueSubject<Int, Never>) {
            self.subscriber = subscriber

            value.sink(receiveValue: { [weak self] in
                _ = self?.subscriber?.receive($0 > 0)
            }).store(in: &self.cancellations)
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            _ = self.subscriber?.receive(false)

            self.cancellations = []
            self.subscriber = nil
        }
    }
}

#if os(iOS) || os(tvOS)
import UIKit

public extension ActivityPublisher {
    @inline(__always) @inlinable
    static func booleanState(_ style: UIActivityIndicatorView.Style) -> ActivityPublisher {
        APIBooleanLoadingState.shared(style).activityPublisher
    }
}
#endif
