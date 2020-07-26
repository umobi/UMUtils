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

public func >- <T, K: CodingKey, Transform: EncodableTransform>(left: [T], right: (KeyedEncodingContainer<K>.Wrapper<K>, Transform)) where Transform.Input == T {
    try? right.0.container.encode(left.compactMap { right.1.encode($0) }, forKey: right.0.actualKey)
}

public func >- <T, K: CodingKey, Transform: EncodableTransform>(left: [T]?, right: (KeyedEncodingContainer<K>.Wrapper<K>, Transform)) where Transform.Input == T {
    guard let left = left else {
        return
    }

    try? right.0.container.encode(left.compactMap { right.1.encode($0) }, forKey: right.0.actualKey)
}
