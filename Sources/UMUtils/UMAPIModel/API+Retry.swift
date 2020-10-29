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
import RxCocoa
import RxSwift

@available(iOS 12, *)
private extension ObservableType where Element: APIResultWrapper {
    var rawRetryOnConnect: Observable<Element> {
        self.flatMap { result -> Observable<Element> in
            guard result.error?.isBecauseOfBadConnection ?? false else {
                return .just(result)
            }

            return Networking.shared.isConnected
                .filter { $0 }
                .um_single()
                .flatMap { _ in self.rawRetryOnConnect }
                .startWith(result)
        }
    }

    func singleRetryOnConnect(onError: @escaping (Error) -> Bool) -> Observable<Element> {
        self.flatMap { result -> Observable<Element> in
            guard let error = result.error, onError(error) else {
                return .just(result)
            }

            return Networking.shared.isConnected
                .filter { $0 }
                .um_single()
                .flatMap { _ in self.singleRetryOnConnect(onError: onError) }
                .startWith(result)
        }
    }
}

@available(iOS 12, *)
public extension SharedSequence where Element: APIResultWrapper {
    func retryOnConnect(timeout: APIRelativeTimeoutTime) -> Self {
        self.asObservable()
            .retryOnConnect(timeout: timeout)
            .asSharedSequence(onErrorDriveWith: .never())
    }

    func retryOnConnect(timeout: APIRelativeTimeoutTime, onError: @escaping (Error) -> Bool) -> Self {
        self.asObservable()
            .retryOnConnect(timeout: timeout, onError: onError)
            .asSharedSequence(onErrorDriveWith: .never())
    }
}

@available(iOS 12, *)
public extension ObservableType where Element: APIResultWrapper {

    func retryOnConnect(timeout: APIRelativeTimeoutTime) -> Observable<Element> {
        timeout.timeout(
            self.rawRetryOnConnect,
            scheduler: MainScheduler.asyncInstance
        )
    }

    func retryOnConnect(timeout: APIRelativeTimeoutTime, onError: @escaping (Error) -> Bool) -> Observable<Element> {
        timeout.timeout(
            self.singleRetryOnConnect(onError: onError),
            scheduler: MainScheduler.asyncInstance
        )
    }
}

@frozen @available(iOS 12, *)
public enum APIRelativeTimeoutTime {
    case seconds(Int)
    case forever

    func timeout<O, Scheduler>(_ publisher: O, scheduler: Scheduler) -> Observable<O.Element> where O: ObservableType, Scheduler: SchedulerType {
        switch self {
        case .forever:
            return publisher
                .asObservable()
        case .seconds(let seconds):
            return publisher
                .timeout(.seconds(seconds), scheduler: scheduler)
                .asObservable()
        }
    }
}
