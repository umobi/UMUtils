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
import Request
import Combine

class SingleSubject<Publisher>: Subject where Publisher: Combine.Publisher {
    typealias Failure = Publisher.Failure
    typealias Output = Publisher.Output

    enum Payload {
        case output(Output)
        case failure(Failure)
        case finished
        case empty
    }

    var payload: Payload = .empty
    var cancelations: [AnyCancellable] = []

    var onValidPayload: ((Payload) -> Void)? = nil

    func send(_ value: Output) {
        guard case .empty = self.payload else {
            return
        }

        self.payload = .output(value)
        self.cancelations = []

        self.onValidPayload?(self.payload)
    }

    func send(completion: Subscribers.Completion<Failure>) {
        guard case .empty = self.payload else {
            return
        }

        switch completion {
        case .failure(let failure):
            self.payload = .failure(failure)
        case .finished:
            self.payload = .finished
        }

        self.cancelations = []
        self.onValidPayload?(self.payload)
    }

    func send(subscription: Subscription) {
        Swift.print("send(subscription:)", subscription)
    }

    static func commit<S>(payload: Payload, subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        switch payload {
        case .output(let output):
            _ = subscriber.receive(output)
        case .failure(let failure):
            subscriber.receive(completion: .failure(failure))
        case .finished:
            subscriber.receive(completion: .finished)
        case .empty:
            return
        }
    }

    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        guard case .empty = self.payload else {
            Self.commit(payload: self.payload, subscriber: subscriber)
            return
        }

        self.onValidPayload = {
            Self.commit(payload: $0, subscriber: subscriber)
        }
    }

    init(_ publisher: Publisher) {
        let cancellable = publisher.sink {
            self.send(completion: $0)
        } receiveValue: {
            self.send($0)
        }

        if case .empty = self.payload {
            cancellable.store(in: &self.cancelations)
            return
        }
    }
}

public extension Publisher {
    func single() -> AnyPublisher<Output, Failure> {
        SingleSubject(self)
            .eraseToAnyPublisher()
    }
}

private extension Publisher where Output: APIResultWrapper, Failure == Never {
    var rawRetryOnConnect: AnyPublisher<Self.Output, Self.Failure> {
        self.flatMap { result -> AnyPublisher<Self.Output, Self.Failure> in
            guard result.error?.isBecauseOfBadConnection ?? false else {
                return Just(result)
                    .eraseToAnyPublisher()
            }

            return Networking.shared.isConnected
                .filter { $0 }
                .single()
                .flatMap { _ in self.rawRetryOnConnect }
                .prepend(result)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

    func singleRetryOnConnect(onError: @escaping (Error) -> Bool) -> AnyPublisher<Self.Output, Self.Failure> {
        self.flatMap { result -> AnyPublisher<Self.Output, Self.Failure> in
            guard let error = result.error, onError(error) else {
                return Just(result)
                    .eraseToAnyPublisher()
            }

            return Networking.shared.isConnected
                .filter { $0 }
                .single()
                .flatMap { _ in self.singleRetryOnConnect(onError: onError) }
                .prepend(result)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}

public enum APIRelativeTimeoutTime {
    case seconds(Int)
    case forever

    func timeout<Publisher, Scheduler>(_ publisher: Publisher, scheduler: Scheduler) -> AnyPublisher<Publisher.Output, Publisher.Failure> where Publisher: Combine.Publisher, Scheduler: Combine.Scheduler {
        switch self {
        case .forever:
            return publisher
                .eraseToAnyPublisher()
        case .seconds(let seconds):
            return publisher
                .timeout(.seconds(seconds), scheduler: scheduler)
                .eraseToAnyPublisher()
        }
    }
}

public extension Publisher where Output: APIResultWrapper, Failure == Never {

    func retryOnConnect(timeout: APIRelativeTimeoutTime) -> AnyPublisher<Self.Output, Self.Failure> {
        timeout.timeout(
            self.rawRetryOnConnect,
            scheduler: DispatchQueue.main
        )
    }

    func retryOnConnect(timeout: APIRelativeTimeoutTime, onError: @escaping (Error) -> Bool) -> AnyPublisher<Self.Output, Self.Failure> {
        timeout.timeout(
            self.singleRetryOnConnect(onError: onError),
            scheduler: DispatchQueue.main
        )
    }
}

public extension Publisher where Output: APIResultWrapper, Failure == Never {
    func throwErrorToManager() -> AnyPublisher<Output, Failure> {
        self.map {
            if let error = $0.error {
                APIErrorManager.shared?.didReviceError(error)
            }

            return $0
        }
        .eraseToAnyPublisher()
    }
}
