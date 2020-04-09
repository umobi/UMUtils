//
//  Result.swift
//  TokBeauty
//
//  Created by brennobemoura on 09/08/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import Foundation

public protocol APIResultWrapper {
    var error: Error? { get }
}

public enum APIResult<T: Decodable>: APIResultWrapper {
    case success(T)
    case stepSuccess(T)
    case error(Error)
    case undefined
    case empty
}

public extension APIResult {
    var error: Error? {
        guard case .error(let error) = self else {
            return nil
        }

        return error
    }
}
