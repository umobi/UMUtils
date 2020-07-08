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

#if os(iOS) || os(tvOS)
import SwiftUI
import UIKit

struct UMActivity: UIViewRepresentable {
    private let style: UIActivityIndicatorView.Style
    private let color: UIColor

    init(style: UIActivityIndicatorView.Style) {
        self.style = style
        self.color = .black
    }

    private init(_ original: UMActivity, editable: Editable) {
        self.style = original.style
        self.color = editable.color
    }

    private class Editable {
        var color: UIColor

        init(_ original: UMActivity) {
            self.color = original.color
        }
    }

    private func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    func color(_ color: UIColor) -> Self {
        self.edit {
            $0.color = color
        }
    }

    func makeUIView(context: Context) -> View {
        return View(style: self.style)
    }

    func updateUIView(_ uiView: View, context: Context) {
        uiView.style = self.style
        uiView.color = self.color
    }
}

extension UMActivity {
    class View: UIActivityIndicatorView {
        override func didMoveToWindow() {
            super.didMoveToWindow()

            if self.window != nil && !self.isAnimating {
                self.startAnimating()
                return
            }

            self.stopAnimating()
        }
    }
}
#endif
