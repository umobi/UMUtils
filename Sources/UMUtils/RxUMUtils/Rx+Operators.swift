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

import Combine

// MARK: - isSucceeded()

extension Publisher {
    public func isSucceeded() -> Publishers.ReplaceError<Publishers.Map<Self, Bool>> {
        self.map(true)
            .replaceError(with: false)
    }
}


// MARK: - map()

extension Publisher {
    public func map<T>(_ element: T) -> Publishers.Map<Self, T> {
        self.map { _ in element }
    }
}

// MARK: - mapVoid()

extension Publisher {
    public func mapVoid() -> Publishers.Map<Self, Void> {
        self.map(Void())
    }
}

// MARK: - ignoreErrors()

extension Publisher {
    public func ignoreErrors() -> Publishers.Catch<Self, Empty<Self.Output, Self.Failure>> {
        self.catch { _ in Empty<Self.Output, Self.Failure>() }
    }
}
