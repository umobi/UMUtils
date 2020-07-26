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
import Request

extension Publisher where Output: APIResultWrapper, Failure == Never {
    func filter<R: RangeExpression>(statusCodes: R) -> AnyPublisher<Output, Failure> where R.Bound == Int {
        self.filter {
            guard
                let error = $0.error,
                let urlError = error as? RequestError,
                statusCodes.contains(urlError.statusCode)
            else { return true }

            return false
        }
        .eraseToAnyPublisher()
    }

    func filter(statusCode: Int) -> AnyPublisher<Output, Failure> {
        self.filter {
            guard
                let error = $0.error,
                let urlError = error as? RequestError,
                statusCode == urlError.statusCode
            else { return true }

            return false
        }
        .eraseToAnyPublisher()
    }
}

public extension Publisher where Output: APIResultWrapper, Failure == Never {
    func filterSuccessfulCodes() -> AnyPublisher<Output, Failure> {
        self.filter(statusCodes: 200...299)
    }

    func filterSuccessfulAndRedirectCodes() -> AnyPublisher<Output, Failure> {
        self.filter(statusCodes: 200...399)
    }
}
