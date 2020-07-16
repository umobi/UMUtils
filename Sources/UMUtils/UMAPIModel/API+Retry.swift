//
//  File.swift
//  
//
//  Created by brennobemoura on 16/07/20.
//

import Foundation
import RxCocoa
import RxSwift

@available(iOS 12, *)
extension SharedSequence where Element: APIResultWrapper {
    var rawRetryOnConnect: SharedSequence<DriverSharingStrategy, Element> {
            self.flatMapLatest { result -> SharedSequence<DriverSharingStrategy, Element> in
                guard result.error?.isBecauseOfBadConnection ?? false else {
                    return .just(result)
                }

                return Networking.shared.isConnected
                    .flatMapLatest { isConnected -> SharedSequence<DriverSharingStrategy, Element> in
                        guard isConnected else {
                            return .never()
                        }

                        return self.rawRetryOnConnect
                    }
                    .first()
                    .asSharedSequence(sharingStrategy: SharingStrategy.self, onErrorDriveWith: .never())
                    .flatMapLatest {
                        guard let result = $0 else {
                            return .never()
                        }

                        return .just(result)
                    }

            }
        }

        func singleRetryOnConnect(onError: @escaping (Error) -> Bool) -> SharedSequence<DriverSharingStrategy, Element> {
            self.flatMap { result -> SharedSequence<DriverSharingStrategy, Element> in
                guard let error = result.error, onError(error) else {
                    return .just(result)
                }

                return Networking.shared.isConnected
                    .flatMap { isConnected -> SharedSequence<DriverSharingStrategy, Element> in
                        guard isConnected else {
                            return .never()
                        }

                        return self.singleRetryOnConnect(onError: onError)
                    }
                    .first()
                    .asSharedSequence(sharingStrategy: SharingStrategy.self, onErrorDriveWith: .never())
                    .flatMapLatest {
                        guard let result = $0 else {
                            return .never()
                        }

                        return .just(result)
                    }
            }
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
