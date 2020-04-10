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
import Moya

public extension Swift.Error {
    var isSessionExpired: Bool {
        if let moyaError = self as? MoyaError, let response = moyaError.response, response.statusCode == 401 {
            return true
        }
        return false
    }
}

public protocol APIErrorDelegate {
    func didReviceError(_ error: Swift.Error)
}

public class APIErrorManager {
    private(set) static var shared: APIErrorManager?
    let delegate: APIErrorDelegate

    init(_ delegate: APIErrorDelegate) {
        self.delegate = delegate
    }

    public static func tracked(by delegate: APIErrorDelegate) {
        self.shared = .init(delegate)
    }

    func didReviceError(_ error: Swift.Error) {
        self.delegate.didReviceError(error)
    }
}

public extension APIError {
    static func mount(from error: Swift.Error) -> APIError? {
        do {
            switch error {
            case let moyaError as MoyaError:
                if let response = moyaError.response {
                    return try JSONDecoder().decode(APIError.self, from: response.data)
                }

                if case .underlying((let error, _)) = moyaError {
                    return .init(error: error)
                }

                return .init(error: moyaError)

            case let decodingError as DecodingError:
                return .init(error: decodingError)

            default:
                return nil
            }
        } catch {
            return nil
        }
    }
}
