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
