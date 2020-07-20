//
//  File.swift
//
//
//  Created by brennobemoura on 16/07/20.
//

import Foundation
import RxCocoa
import RxSwift

private struct Collapsed<Wrapper>: Error where Wrapper: APIResultWrapper {
    let error: Error
    let wrapper: Wrapper
}

@available(iOS 12, *)
private extension ObservableType where Element: APIResultWrapper {
    func apiFlapMapError(onError: ((Error) -> Bool)? = nil) -> Observable<Element> {
        self.flatMap { result -> Observable<Element> in
            if let error = result.error {
                if let onError = onError {
                    if onError(error) {
                        return .error(Collapsed(error: error, wrapper: result))
                    }
                } else if error.isBecauseOfBadConnection {
                    return .error(Collapsed(error: error, wrapper: result))
                }
            }

            return .just(result)
        }
    }

    func apiRetryWhen() -> Observable<Element> {
        self.retryWhen {
            $0.flatMapLatest { _ in
                Networking.shared
                    .isConnected
                    .filter { $0 }
            }
        }
    }

    func apiRestoreError() -> Observable<Element> {
        self.catchError { error -> Observable<Element> in
            guard let collapsed = error as? Collapsed<Element> else {
                return .never()
            }

            return .just(collapsed.wrapper)
        }
    }
}

@available(iOS 12, *)
extension SharedSequence where Element: APIResultWrapper {
    var rawRetryOnConnect: SharedSequence<DriverSharingStrategy, Element> {
        self.asObservable()
            .apiFlapMapError()
            .apiRetryWhen()
            .apiRestoreError()
            .asSharedSequence(onErrorDriveWith: .never())
    }

    func singleRetryOnConnect(onError: @escaping (Error) -> Bool) -> SharedSequence<DriverSharingStrategy, Element> {
        self.asObservable()
            .apiFlapMapError(onError: onError)
            .apiRetryWhen()
            .apiRestoreError()
            .asSharedSequence(onErrorDriveWith: .never())
    }
}

public enum APIRelativeTimeoutTime {
    case seconds(Int)
    case forever

    func timeout<SharingStrategy, Element>(_ driver: SharedSequence<SharingStrategy, Element>, scheduler: SchedulerType) -> SharedSequence<SharingStrategy, Element> {
        switch self {
        case .forever:
            return driver
        case .seconds(let seconds):
            return driver
                .asObservable()
                .timeout(.seconds(seconds), scheduler: scheduler)
                .asSharedSequence(sharingStrategy: SharingStrategy.self, onErrorDriveWith: .never())
        }
    }
}

@available(iOS 12, *)
public extension SharedSequence where Element: APIResultWrapper {

    func retryOnConnect(timeout: APIRelativeTimeoutTime) -> SharedSequence<DriverSharingStrategy, Element> {
        timeout.timeout(self.rawRetryOnConnect, scheduler: MainScheduler.asyncInstance)
    }

    func retryOnConnect(timeout: APIRelativeTimeoutTime, onError: @escaping (Error) -> Bool) -> SharedSequence<DriverSharingStrategy, Element> {
        timeout.timeout(self.singleRetryOnConnect(onError: onError), scheduler: MainScheduler.asyncInstance)
    }
}
