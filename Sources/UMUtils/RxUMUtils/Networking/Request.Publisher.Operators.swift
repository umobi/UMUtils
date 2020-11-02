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

public extension Publisher where Output: APIResultWrapper, Failure == Never {
    @inlinable
    func filter(urlErrorCodes: Set<URLError.Code>) -> AnyPublisher<Output, Failure> {
        self.filter {
            guard
                let error = $0.error,
                let urlError = error as? URLError,
                urlErrorCodes.contains(urlError.code)
            else { return true }

            return false
        }
        .eraseToAnyPublisher()
    }

    @inline(__always) @inlinable
    func filter(urlErrorCodes: URLError.Code...) -> AnyPublisher<Output, Failure> {
        self.filter(urlErrorCodes: .init(urlErrorCodes))
    }
}

public extension Publisher where Output: APIResultWrapper, Failure == Never {
    @inlinable
    func successOrError<T>() -> AnyPublisher<T, Error> where Output == APIResult<T>, T: Decodable {
        self.tryMap { result -> Output in
            if case .error(let error) = result {
                throw error
            }

            return result
        }.flatMap { result -> AnyPublisher<T, Error> in
            switch result {
            case .success(let wrapper):
                return Just(wrapper)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            default:
                return Empty()
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
}
