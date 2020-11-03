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
#elseif os(macOS)
import AppKit
#endif

@propertyWrapper @frozen
public struct Outlet<Object> where Object: NSObject {
    @usableFromInline
    class Box {
        weak var object: Object!
    }

    private let box: Box

    public init() {
        self.box = .init()
    }

    public var wrappedValue: Object! {
        self.box.object
    }

    public var projectedValue: Outlet<Object> { self }

    public func ref(_ object: Object!) {
        self.box.object = object
    }
}

#if os(iOS) || os(tvOS)
struct OutletView<Object>: UIViewRepresentable where Object: UIView {
    @Outlet var object: Object!

    init(_ outlet: Outlet<Object>) {
        self._object = outlet
    }

    func makeUIView(context: Context) -> UIViewType {
        UIViewType(frame: .zero)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.onWindow {
            $object.ref(
                sequence(first: $0, next: { $0.superview })
                    .first(where: { $0 is Object }) as? Object
            )
        }
    }
}

extension OutletView {
    class UIViewType: UIView {
        var windowHandler: ((UIView) -> Void)?

        func onWindow(_ handler: @escaping (UIView) -> Void) {
            if self.window != nil {
                handler(self)
                return
            }

            windowHandler = handler
        }

        override func didMoveToWindow() {
            super.didMoveToWindow()

            guard window != nil else {
                return
            }

            windowHandler?(self)
        }
    }
}
#elseif os(macOS)
struct OutletView<Object>: NSViewRepresentable where Object: NSView {
    @Outlet var object: Object!

    init(_ outlet: Outlet<Object>) {
        self._object = outlet
    }

    func makeNSView(context: Context) -> NSViewType {
        NSViewType(frame: .zero)
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
        nsView.onWindow {
            $object.ref(
                sequence(first: $0, next: { $0.superview })
                    .first(where: { $0 is Object }) as? Object
            )
        }
    }
}

extension OutletView {
    class NSViewType: NSView {
        var windowHandler: ((NSView) -> Void)?

        func onWindow(_ handler: @escaping (NSView) -> Void) {
            if self.window != nil {
                handler(self)
                return
            }

            windowHandler = handler
        }

        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()

            guard window != nil else {
                return
            }

            windowHandler?(self)
        }
    }
}
#endif

extension View {
    #if os(iOS) || os(tvOS)
    func `as`<Object>(_ outlet: Outlet<Object>) -> some View where Object: UIView {
        self.background(OutletView(outlet))
    }
    #elseif os(macOS)
    func `as`<Object>(_ outlet: Outlet<Object>) -> some View where Object: NSView {
        self.background(OutletView(outlet))
    }
    #endif
}
