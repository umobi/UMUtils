//
//  Transform.swift
//  UMUtils
//
//  Created by brennobemoura on 18/11/19.
//

import Foundation

public protocol DecodableTransform {
    associatedtype Input
    associatedtype Output: Decodable

    func decode(_ value: Output) -> Input?
}

public protocol EncodableTransform {
    associatedtype Input
    associatedtype Output: Encodable

    func encode(_ value: Input?) -> Output?
}

public typealias CodableTransform = EncodableTransform & DecodableTransform
