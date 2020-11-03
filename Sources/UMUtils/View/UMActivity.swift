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
public struct UMActivity<Content>: View where Content: View {
    @Mutable private var timer: Timer? = nil
    @State private var height: CGFloat = 0

    @Binding private var isAnimating: Bool
    @Binding private var blurColor: Color
    @Binding private var color: Color
    @Binding private var style: UIActivityIndicatorView.Style

    private let contents: () -> Content

    private let mode: Mode
    private let size: Size

    #if os(iOS) || os(tvOS)

    public init(
        _ blurColor: Binding<Color>,
        style: Binding<UIActivityIndicatorView.Style> = .constant(.medium),
        color: Binding<Color>,
        size: Size = .medium,
        mode: Mode = .forever,
        isAnimating: Binding<Bool>,
        @ViewBuilder contents: @escaping () -> Content) {

        self._blurColor = blurColor
        self._isAnimating = isAnimating
        self._color = color
        self._style = style
        self.size = size
        self.mode = mode
        self.contents = contents
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

    @ViewBuilder
    public var body: some View {
        if isAnimating {
            ZStack {
                blurColor
                    .opacity(0.15)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .blur(radius: 20)

                ZStack {
                    VStack(spacing: 7.5) {
                        #if os(iOS) || os(tvOS)
                        ActivityView(style, color)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
                        #elseif os(macOS)
                        UMActivity(size: self.size, tint: self.tint)
                            .padding(.all, 15)
                        #endif

                        if !(Content.self is Never.Type) {
                            ScrollView {
                                contents()
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
}

extension UMActivity where Content == Never {
    public init(
        _ blurColor: Binding<Color>,
        style: Binding<UIActivityIndicatorView.Style> = .constant(.medium),
        color: Binding<Color>,
        size: Size = .medium,
        mode: Mode = .forever,
        isAnimating: Binding<Bool>) {

        self._blurColor = blurColor
        self._isAnimating = isAnimating
        self._color = color
        self._style = style
        self.size = size
        self.mode = mode
        self.contents = { fatalError() }
    }
}

public extension UMActivity {
    @frozen
    enum Size {
        case small
        case medium
        case large

        fileprivate var factor: CGFloat {
            switch self {
            case .small:
                return 1
            case .medium:
                return 1.5
            case .large:
                return 2
            }
        }
    }
}

public extension UMActivity {
    @frozen
    enum Mode {
        case forever
        case until(TimeInterval)
    }
}
#endif

#if os(iOS) || os(tvOS)
public extension View {
    @inlinable
    func activityIndicator<Content>(
        _ blurColor: Binding<Color>,
        style: Binding<UIActivityIndicatorView.Style> = .constant(.medium),
        color: Binding<Color>,
        size: UMActivity<Content>.Size = .medium,
        mode: UMActivity<Content>.Mode = .forever,
        isAnimating: Binding<Bool>,
        @ViewBuilder contents: @escaping () -> Content
    ) -> some View where Content: View {

        ZStack {
            self.frame(maxWidth: .infinity, maxHeight: .infinity)

            UMActivity(
                blurColor,
                style: style,
                color: color,
                size: size,
                mode: mode,
                isAnimating: isAnimating,
                contents: contents
            )
        }
    }

    @inlinable
    func activityIndicator(
        _ blurColor: Binding<Color>,
        style: Binding<UIActivityIndicatorView.Style> = .constant(.medium),
        color: Binding<Color>,
        size: UMActivity<Never>.Size = .medium,
        mode: UMActivity<Never>.Mode = .forever,
        isAnimating: Binding<Bool>
    ) -> some View {

        ZStack {
            self.frame(maxWidth: .infinity, maxHeight: .infinity)

            UMActivity(
                blurColor,
                style: style,
                color: color,
                size: size,
                mode: mode,
                isAnimating: isAnimating
            )
        }
    }
}
#endif
