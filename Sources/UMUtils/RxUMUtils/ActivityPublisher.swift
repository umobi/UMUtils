//
//  File.swift
//  
//
//  Created by brennobemoura on 15/07/20.
//

import Foundation
import Combine

public struct ActivityPublisher: Publisher {
    public typealias Output = Bool
    public typealias Failure = Never

    private let subject = CurrentValueSubject<Int, Never>(0)

    public init() {}

    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        subscriber.receive(subscription: Subscription(subscriber, self.subject))
    }

    func increment() {
        self.subject.value += 1
    }

    func decrement() {
        self.subject.value = abs(self.subject.value - 1)
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
    static func booleanState(_ style: UIActivityIndicatorView.Style) -> ActivityPublisher {
        APIBooleanLoadingState.shared(style).activityPublisher
    }
}
#endif
