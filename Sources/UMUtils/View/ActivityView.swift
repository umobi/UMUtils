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

public struct ActivityView: UIViewRepresentable {
    @Binding var style: UIActivityIndicatorView.Style
    @Binding var color: UIColor

    public init(_ style: Binding<UIActivityIndicatorView.Style>,_ color: Binding<UIColor>) {
        self._style = style
        self._color = color
    }

    public init(_ style: UIActivityIndicatorView.Style, _ color: UIColor) {
        self._style = .constant(style)
        self._color = .constant(color)
    }

    public func makeUIView(context: Context) -> View {
        View(style: self.style)
    }

    public func updateUIView(_ uiView: View, context: Context) {
        uiView.style = style
        uiView.color = color
    }
}

public extension ActivityView {
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
public struct ActivityView: NSViewRepresentable {

    @Binding var size: NSControl.ControlSize
    @Binding var tint: NSControlTint

    public init(_ size: Binding<NSControl.ControlSize>, _ tint: Binding<NSControlTint>) {
        self._size = size
        self._tint = tint
    }

    public init(_ style: NSControl.ControlSize, _ color: NSControlTint) {
        self._size = .constant(style)
        self._tint = .constant(color)
    }

    public func makeNSView(context: Context) -> View {
        return View()
    }

    public func updateNSView(_ progressIndicator: View, context: Context) {
        progressIndicator.style = .spinning
        progressIndicator.controlSize = size
        progressIndicator.controlTint = tint
    }
}

public extension ActivityView {
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
