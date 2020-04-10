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

#if !COCOAPODS
import UMCore
#endif

public struct APIException: Codable {
    
    public let line: Int
    public let severity: String
    public let type: String
    public let file: String
    public let message: String
    
    public let trace: [String]?
    
    public init(line: Int, severity: String, type: String, file: String, message: String, trace: [String]?) {
        self.line = line
        self.severity = severity
        self.type = type
        self.file = file
        self.message = message
        self.trace = trace
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.line = (try? container.decode(.line)) ?? 0
        self.message = (try? container.decode(.message)) ?? ""
        self.severity = (try? container.decode(.severity)) ?? ""
        self.type = (try? container.decode(.type)) ?? ""
        self.file = (try? container.decode(.file)) ?? ""
        self.trace = try? container.decode(.trace)
    }

    public func encode(to encoder: Encoder) {
        let container = encoder.container(keyedBy: CodingKeys.self).wrapper

        self.line >- container[.line]
        self.message >- container[.message]
        self.severity >- container[.severity]
        self.file >- container[.file]
        self.type >- container[.type]
        self.trace >- container[.trace]
    }
}

extension APIException {
    enum CodingKeys: String, CodingKey {
        case line
        case severity
        case type
        case file
        case message
        case trace
    }
}
