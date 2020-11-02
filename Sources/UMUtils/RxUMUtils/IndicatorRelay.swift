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

@propertyWrapper
public struct IndicatorRelay: ObservableConvertibleType {
    public typealias Element = Bool

    @Value @usableFromInline
    var requestsCount: Int = .zero

    private let lock = NSRecursiveLock()

    @inlinable
    public init() {}

    private func increment() {
        lock.lock()
        requestsCount += 1
        lock.unlock()
    }

    private func decrement() {
        lock.lock()
        requestsCount -= 1
        lock.unlock()
    }

    // swiftlint:disable multiple_closures_with_trailing_closure
    @usableFromInline
    func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        return Observable.using({ () -> Token<O.Element> in
            self.increment()
            return Token(source: source.asObservable(), disposeAction: self.decrement)
        }) { token in
            return token.asObservable()
        }
    }

    @inline(__always) @inlinable
    public var wrappedValue: Bool {
        self.requestsCount == .zero
    }

    @inline(__always)
    public var projectedValue: Relay<Bool> {
        self.$requestsCount.map { $0 > .zero }
    }

    public func asObservable() -> Observable<Element> {
        self.$requestsCount.observable
            .map { $0 > 0 }
            .distinctUntilChanged()
    }
}

private extension IndicatorRelay {
    struct Token<Element>: ObservableConvertibleType, Disposable {
        private let _source: Observable<Element>
        private let _dispose: Cancelable

        init(source: Observable<Element>, disposeAction: @escaping () -> Void) {
            _source = source
            _dispose = Disposables.create(with: disposeAction)
        }

        func dispose() {
            _dispose.dispose()
        }

        @inline(__always)
        func asObservable() -> Observable<Element> {
            _source
        }
    }
}

public extension Relay {
    @inlinable
    var observable: Observable<Value> {
        let behavior = BehaviorRelay(value: self.wrappedValue)
        self.sync(behavior.accept)
        return behavior.asObservable()
    }
}

extension ObservableConvertibleType {
    @inline(__always) @inlinable
    public func trackActivity(_ activityIndicator: IndicatorRelay) -> Observable<Element> {
        activityIndicator.trackActivityOfObservable(self)
    }
}
