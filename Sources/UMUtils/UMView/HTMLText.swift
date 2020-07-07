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

import SwiftUI
import WebKit

public struct HTMLText: UIViewRepresentable {
    public typealias UIViewType = WKWebView

    private let htmlString: String

    init(htmlString: String,
         fontFamily: String = "-apple-system",
         fontSize: CGFloat = UIFont.systemFontSize) {

        let styleTagString = Self.styleForFont(family: fontFamily, size: fontSize)
        let htmlString = styleTagString + htmlString

        self.htmlString = htmlString
    }

    public func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(self.htmlString, baseURL: nil)
    }

    private static func styleForFont(family: String, size: CGFloat) -> String {
        return "<style>body{font-family: '\(family)';font-size: \(size)px;}</style>"
    }
}
