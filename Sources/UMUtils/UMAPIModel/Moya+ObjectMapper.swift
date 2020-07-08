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

public extension Request {
    struct Publisher<Output>: Combine.Publisher where Output: Decodable {
        public typealias Failure = Error

        let request: AnyRequest<Data>
        init(_ request: AnyRequest<Data>) {
            self.request = request
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            subscriber.receive(subscription: Request.Subscription(subscriber: subscriber, request: self.request))
        }
    }
}

extension Request {
    final class Subscription<SubscriberType: Subscriber, Object: Decodable>: Combine.Subscription where SubscriberType.Input == Object, SubscriberType.Failure == Error {
        private var subscriber: SubscriberType?
        private let request: AnyRequest<Data>

        init(subscriber: SubscriberType, request: AnyRequest<Data>) {
            self.subscriber = subscriber
            self.request = request

            self.request.onData { [weak self] in
                self?.onData($0)
            }.onError { [weak self] in
                self?.onError($0)
            }.call()
        }

        func request(_ demand: Subscribers.Demand) {
            // We do nothing here as we only want to send events when they occur.
            // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
        }

        func cancel() {
            subscriber = nil
        }

        func onData(_ data: Data) {
            do {
                let object = try JSONDecoder().decode(Object.self, from: data)
                _ = self.subscriber?.receive(object)
            } catch let error {
                self.subscriber?.receive(completion: .failure(error))
            }
        }

        func onError(_ error: Error) {
            subscriber?.receive(completion: .failure(error))
        }
    }
}

public extension Request {
    func publisher<Object>(_ decodable: Object.Type) -> Request.Publisher<Object> where Object: Decodable {
        .init(self)
    }

    func apiPublisher<Object>(_ decodable: Object.Type) -> Publishers.Catch<Publishers.Map<Request.Publisher<Object>, APIResult<Object>>, Just<APIResult<Object>>> where Object: Decodable {
        self.publisher(Object.self)
            .map { .success($0) }
            .catch {
                if let requestError = $0 as? RequestError, requestError.statusCode == 204 {
                    return Just(.empty)
                }

                return Just(.error($0))
        }
    }
}

public extension Error {
    var isBecauseOfBadConnection: Bool {
        guard let urlError = self as? URLError else {
            return false
        }

        switch urlError.code {
        case .backgroundSessionWasDisconnected, .notConnectedToInternet, .networkConnectionLost, .cannotConnectToHost:
            return true
        default:
            return false
        }
    }
}

public extension Publisher where Output: APIResultWrapper, Failure == Never {
    private var retryOnConnect: AnyPublisher<Self.Output, Self.Failure> {
        self.flatMap { result -> AnyPublisher<Self.Output, Self.Failure> in
            guard result.error?.isBecauseOfBadConnection ?? false else {
                return Just(result)
                    .eraseToAnyPublisher()
            }

            return Networking.shared.isConnected
                .flatMap { isConnected -> AnyPublisher<Self.Output, Self.Failure> in
                    guard isConnected else {
                        return Empty()
                            .eraseToAnyPublisher()
                    }

                    return self.retryOnConnect
                        .eraseToAnyPublisher()
                }
                .first()
                .eraseToAnyPublisher()

        }
        .eraseToAnyPublisher()
    }

    func retryOnConnect(timeout: TimeInterval) -> AnyPublisher<Self.Output, Self.Failure> {
        self.retryOnConnect
            .timeout(.seconds(timeout), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func singleRetryOnConnect(onError: @escaping (Error) -> Bool) -> AnyPublisher<Self.Output, Self.Failure> {
        self.flatMap { result -> AnyPublisher<Self.Output, Self.Failure> in
            guard let error = result.error, onError(error) else {
                return Just(result)
                    .eraseToAnyPublisher()
            }

            return Networking.shared.isConnected
                .flatMap { isConnected -> AnyPublisher<Self.Output, Self.Failure> in
                    guard isConnected else {
                        return Empty()
                            .eraseToAnyPublisher()
                    }

                    return self.singleRetryOnConnect(onError: onError)
                        .eraseToAnyPublisher()
                }
                .first()
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

    func retryOnConnect(timeout: TimeInterval, onError: @escaping (Error) -> Bool) -> AnyPublisher<Self.Output, Self.Failure> {
        self.singleRetryOnConnect(onError: onError)
            .timeout(.seconds(timeout), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

func a() {
    Request {
        Url("https://jsonplaceholder.typicode.com/posts")
        Method(.post)
        Header.ContentType(.json)
        Body([
            "title": "foo",
            "body": "bar",
            "usedId": 1
        ])
    }
    .apiPublisher(APIObject<Int>.self)
}
