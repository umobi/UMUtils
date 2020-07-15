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

#if os(iOS) || os(tvOS)
import UIKit

public struct UMActivity: UIViewRepresentable {
    private let style: UIActivityIndicatorView.Style
    private let color: UIColor

    public init(style: UIActivityIndicatorView.Style) {
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

    public func color(_ color: UIColor) -> Self {
        self.edit {
            $0.color = color
        }
    }

    public func makeUIView(context: Context) -> View {
        return View(style: self.style)
    }

    public func updateUIView(_ uiView: View, context: Context) {
        uiView.style = self.style
        uiView.color = self.color
    }
}

public extension UMActivity {
    class View: UIActivityIndicatorView {
        public override func didMoveToWindow() {
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

#if os(macOS)
public struct UMActivity: NSViewRepresentable {

    private let size: NSControl.ControlSize
    private let tint: NSControlTint

    public init(size: NSControl.ControlSize, tint: NSControlTint) {
        self.size = size
        self.tint = tint
    }

    public func makeNSView(context: Context) -> View {
        return View()
    }

    public func updateNSView(_ progressIndicator: View, context: Context) {
        progressIndicator.style = .spinning
        progressIndicator.controlSize = self.size
        progressIndicator.controlTint = self.tint
    }
}

public extension UMActivity {
    class View: NSProgressIndicator {
        private(set) var isAnimating: Bool = false

        public override func startAnimation(_ sender: Any?) {
            super.startAnimation(sender)
            self.isAnimating = true
        }

        public override func stopAnimation(_ sender: Any?) {
            super.stopAnimation(sender)
            self.isAnimating = false
        }

        public func startAnimating() {
            self.startAnimation(self)
        }

        public func stopAnimating() {
            self.stopAnimation(self)
        }

        public override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()

            if self.window != nil && !self.isAnimating {
                self.startAnimating()
                return
            }

            self.stopAnimating()
        }
    }
}
#endif
