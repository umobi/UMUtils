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

#if os(iOS) || os(tvOS) || os(macOS)
public struct ActivityView: View {

    #if os(iOS) || os(tvOS)
    private let style: UIActivityIndicatorView.Style
    private let color: UIColor
    #elseif os(macOS)
    private let size: NSControl.ControlSize
    private let tint: NSControlTint
    #endif

    private let title: String?
    private let titleColor: Color?
    private let titleFont: Font?

    #if os(iOS) || os(tvOS)
    public init(style: UIActivityIndicatorView.Style) {
        self.style = style
        self.color = .black
        self.title = nil
        self.titleColor = nil
        self.titleFont = nil
    }
    #elseif os(macOS)
    public init(tint: NSControlTint) {
        self.size = .regular
        self.tint = tint
        self.title = nil
        self.titleColor = nil
        self.titleFont = nil
    }
    #endif

    private init(_ original: ActivityView, editable: Editable) {
        #if os(iOS) || os(tvOS)
        self.style = original.style
        self.color = editable.color
        #elseif os(macOS)
        self.size = editable.size
        self.tint = original.tint
        #endif

        self.title = editable.title
        self.titleColor = editable.titleColor
        self.titleFont = editable.titleFont
    }

    @State private var height: CGFloat = 0

    public var body: some View {
        ZStack {
            Color.black
                .opacity(0.15)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

            ZStack {
                VStack(spacing: 7.5) {
                    #if os(iOS) || os(tvOS)
                    UMActivity(style: self.style)
                        .color(self.color)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
                    #elseif os(macOS)
                    UMActivity(size: self.size, tint: self.tint)
                        .padding(.all, 15)
                    #endif

                    if let title = self.title {
                        ScrollView {
                            Text(title)
                                .foregroundColor(self.titleColor ?? .black)
                                .font(self.titleFont ?? .body)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: 150)
                                .background(GeometryReader { geometry -> AnyView in
                                    OperationQueue.main.addOperation {
                                        self.height = geometry.size.height
                                    }

                                    return AnyView(Rectangle().fill(Color.clear))
                                })
                        }
                        .frame(maxHeight: self.height)
                    }
                }
                .layoutPriority(2)
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
            .background({ () -> UMBlur in
                #if os(iOS) || os(tvOS)
                return UMBlur()
                #elseif os(macOS)
                return UMBlur(material: .contentBackground, blendingMode: .withinWindow)
                #endif
            }())
            .cornerRadius(7.5)
            .shadow(
                color: Color.black.opacity(0.15),
                radius: 5,
                x: 2, y: 3
            )
        }
    }
}

extension ActivityView {
    @usableFromInline
    class Editable {
        #if os(iOS) || os(tvOS)
        @usableFromInline
        var color: UIColor
        #elseif os(macOS)
        @usableFromInline
        var size: NSControl.ControlSize
        #endif
        @usableFromInline
        var title: String?

        @usableFromInline
        var titleColor: Color?

        @usableFromInline
        var titleFont: Font?

        init(_ original: ActivityView) {
            #if os(iOS) || os(tvOS)
            self.color = original.color
            #elseif os(macOS)
            self.size = original.size
            #endif

            self.title = original.title
            self.titleColor = original.titleColor
            self.titleFont = original.titleFont
        }
    }

    @inline(__always) @usableFromInline
    func edit(_ edit: (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}

public extension ActivityView {

    #if os(iOS) || os(tvOS)
    @inlinable
    func color(_ color: UIColor) -> Self {
        self.edit {
            $0.color = color
        }
    }
    #elseif os(macOS)
    @inlinable
    func size(_ size: NSControl.ControlSize) -> Self {
        self.edit {
            $0.size = size
        }
    }
    #endif

    @inlinable
    func title(_ title: String) -> Self {
        self.edit {
            $0.title = title
        }
    }

    @inlinable
    func titleColor(_ color: Color) -> Self {
        self.edit {
            $0.titleColor = color
        }
    }

    @inlinable
    func titleFont(_ font: Font) -> Self {
        self.edit {
            $0.titleFont = font
        }
    }
}
#endif
