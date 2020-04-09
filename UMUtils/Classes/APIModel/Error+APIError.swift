//
//  Error+APIError.swift
//  TokBeauty
//
//  Created by brennobemoura on 09/08/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
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
