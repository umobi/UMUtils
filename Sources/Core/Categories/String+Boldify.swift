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

public extension NSAttributedString {
    func boldify(with string: String) -> NSAttributedString {
        return self.setAttributes([.font: UIFont(name: "HelveticaNeue-Bold", size: 15)!], string: string)
    }

    func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, string: String) -> NSAttributedString {
        let nsString = self.string as NSString
        let attributedString = NSMutableAttributedString(attributedString: self)

        let range = nsString.range(of: string)

        if range.location != NSNotFound {
            attributedString.setAttributes(attrs, range: range)
        }

        return attributedString
    }
}

public extension NSString {
    func boldify(with string: String) -> NSAttributedString {
        let attributedString = NSAttributedString(string: self as String)
        return attributedString.boldify(with:string)
    }

    func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, string: String) -> NSAttributedString {
        return NSAttributedString(string: self as String).setAttributes(attrs, string: string)
    }
}

public extension String {
    func boldify(with string: String) -> NSAttributedString {
        return (self as NSString).boldify(with:string)
    }

    func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, string: String) -> NSAttributedString {
        return (self as NSString).setAttributes(attrs, string: string)
    }
}
