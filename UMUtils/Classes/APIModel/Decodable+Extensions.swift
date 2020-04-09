//
//  Decodable+Extensions.swift
//  UMUtils
//
//  Created by brennobemoura on 18/11/19.
//

import Foundation

public extension KeyedDecodingContainer {
    func decode<T: Decodable>(_ key: K) throws -> T {
        return try self.decode(T.self, forKey: key)
    }

    func decode<T, Transform: DecodableTransform>(_ key: K, using transform: Transform) throws -> T where Transform.Input == T {

        guard let value = transform.decode(try self.decode(Transform.Output.self, forKey: key)) else {
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Transformer \(Transform.self) return nil")
        }

        return value
    }

    func decode<T, Transform: DecodableTransform>(_ key: K, using transform: Transform) throws -> T? where Transform.Input == T {
        guard let value = try self.decodeIfPresent(Transform.Output.self, forKey: key) else {
            return nil
        }

        return transform.decode(value)
    }
}

public extension KeyedDecodingContainer {
    func decode<T, Transform: DecodableTransform>(_ key: K, using transform: Transform) throws -> [T] where Transform.Input == T {

        return try self.decode([Transform.Output].self, forKey: key).map {
            guard let object = transform.decode($0) else {
                throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Transformer \(Transform.self) return nil")
            }

            return object
        }
    }

    func decode<T, Transform: DecodableTransform>(_ key: K, using transform: Transform) throws -> [T?] where Transform.Input == T {
        return try self.decode([Transform.Output].self, forKey: key).map {
            transform.decode($0)
        }
    }

    func decode<T, Transform: DecodableTransform>(_ key: K, using transform: Transform) throws -> [T]? where Transform.Input == T {
        return try self.decodeIfPresent([Transform.Output].self, forKey: key)?.map {
            guard let object = transform.decode($0) else {
                throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Transformer \(Transform.self) return nil")
            }

            return object
        }
    }

    func decode<T, Transform: DecodableTransform>(_ key: K, using transform: Transform) throws -> [T?]? where Transform.Input == T {
        return try self.decodeIfPresent([Transform.Output].self, forKey: key)?.map {
            transform.decode($0)
        }
    }
}
