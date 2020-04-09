//
//  Encodable+Extensions.swift
//  UMUtils
//
//  Created by brennobemoura on 18/11/19.
//

import Foundation

public extension Encodable {
    func toJSON() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }

        return ((try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any]) ?? [:]
    }

    func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}

public extension KeyedEncodingContainer {
    class Wrapper<K: CodingKey> {
        var container: KeyedEncodingContainer<K>
        let actualKey: K!

        init(_ container: KeyedEncodingContainer<K>) {
            self.container = container
            self.actualKey = nil
        }

        init(_ container: KeyedEncodingContainer<K>, key: K) {
            self.container = container
            self.actualKey = key
        }

        public subscript(_ key: K) -> Wrapper<K> {
            return .init(self.container, key: key)
        }
    }

    var wrapper: Wrapper<K> {
        return .init(self)
    }
}

infix operator >-

public func >- <T: Encodable, K: CodingKey>(left: T, right: KeyedEncodingContainer<K>.Wrapper<K>) {
    try? right.container.encode(left, forKey: right.actualKey)
}

public func >- <T: Encodable, K: CodingKey>(left: T?, right: KeyedEncodingContainer<K>.Wrapper<K>) {
    guard let left = left else {
        return
    }
    
    try? right.container.encode(left, forKey: right.actualKey)
}

public func >- <T, K: CodingKey, Transform: EncodableTransform>(left: T, right: (KeyedEncodingContainer<K>.Wrapper<K>, Transform)) where Transform.Input == T {
    guard let value = right.1.encode(left) else {
        return
    }

    try? right.0.container.encode(value, forKey: right.0.actualKey)
}

public func >- <T, K: CodingKey, Transform: EncodableTransform>(left: T?, right: (KeyedEncodingContainer<K>.Wrapper<K>, Transform)) where Transform.Input == T {
    guard let left = left, let value = right.1.encode(left) else {
        return
    }

    try? right.0.container.encode(value, forKey: right.0.actualKey)
}
