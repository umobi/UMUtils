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

    @frozen
    enum PublisherLodingType {
        case boolean(BooleanIndicator)
    }

    @frozen
    struct Publisher<Output>: Combine.Publisher where Output: Decodable {
        public typealias Failure = Error

        let request: AnyRequest<Data>
        let loadingType: PublisherLodingType

        @usableFromInline
        init(_ request: AnyRequest<Data>,_ type: PublisherLodingType) {
            self.request = request
            self.loadingType = type
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            subscriber.receive(
                subscription: Request.Subscription(
                    subscriber:  subscriber,
                    request: self.request,
                    loadingType: self.loadingType
                )
            )
        }
    }
}

extension Request {
    final class Subscription<SubscriberType: Subscriber, Object: Decodable>: Combine.Subscription where SubscriberType.Input == Object, SubscriberType.Failure == Error {
        private var subscriber: SubscriberType?
        private let request: AnyRequest<Data>

        init(subscriber: SubscriberType, request: AnyRequest<Data>, loadingType: PublisherLodingType) {
            self.subscriber = subscriber
            self.request = request

            switch loadingType {
            case .boolean(let subject):
                subject.increment()

                self.request.onData { [weak self] in
                    subject.decrement()
                    self?.onData($0)
                }.onError { [weak self] in
                    subject.decrement()
                    self?.onError($0)
                }.call()
            }
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
    @inline(__always) @inlinable 
    func publisher<Object>(_ decodable: Object.Type, isLoading: BooleanIndicator = .init()) -> Request.Publisher<Object> where Object: Decodable {
        .init(self, .boolean(isLoading))
    }
}

public extension Request {
    @inlinable
    func apiPublisher<APISuccess>(_ decodable: APISuccess.Type, isLoading: BooleanIndicator = .init()) -> AnyPublisher<APIResult<APISuccess>, Never> where APISuccess: APIRawObject {
        self.publisher(APISuccess.self, isLoading: isLoading)
            .map { .success($0) }
            .catch { result -> AnyPublisher<APIResult<APISuccess>, Never> in
                if let requestError = result as? RequestError, requestError.statusCode == 204 {
                    return Just(.empty)
                        .eraseToAnyPublisher()
                }

                return Just(.error(result))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
