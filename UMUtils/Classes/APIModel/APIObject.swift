//
//  Object.swift
//  TokBeauty
//
//  Created by brennobemoura on 09/08/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import Foundation

open class APIObject<Object: Decodable>: Decodable {
    public let data: Object

    public init(data: Object) {
        self.data = data
    }
}

public extension APIObject {
    enum CodingKeys: String, CodingKey {
        case data
    }
}
