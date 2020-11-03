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
import SwiftUI

#if os(tvOS) || os(iOS)
import UIKit

public struct UMBlur: UIViewRepresentable {
    @Binding private var style: UIBlurEffect.Style

    public init(_ style: UIBlurEffect.Style = .systemMaterial) {
        self._style = .constant(style)
    }

    public init(_ style: Binding<UIBlurEffect.Style>) {
        self._style = style
    }

    public func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: self.style))
    }

    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: self.style)
    }
}

extension View {
    @inline(__always)
    func blur(_ style: UIBlurEffect.Style) -> some View {
        self.background(UMBlur(style))
    }

    @inline(__always)
    func blur(_ style: Binding<UIBlurEffect.Style>) -> some View {
        self.background(UMBlur(style))
    }
}

public extension UMBlur {
    static var systemMaterial: UMBlur {
        UMBlur(.systemMaterial)
    }
}
#endif

#if os(macOS)
import AppKit

public struct UMBlur: NSViewRepresentable {
    @Binding private var material: NSVisualEffectView.Material
    @Binding private var blendingMode: NSVisualEffectView.BlendingMode

    public init(
        _ material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode) {

        self._material = .constant(material)
        self._blendingMode = .constant(blendingMode)
    }

    public init(
        _ material: Binding<NSVisualEffectView.Material>,
        blendingMode: Binding<NSVisualEffectView.BlendingMode>) {

        self._material = material
        self._blendingMode = blendingMode
    }

    public func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
    }

    public func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material = self.material
        visualEffectView.blendingMode = self.blendingMode
    }
}

extension View {
    @inline(__always)
    func blur(
        _ material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode) -> some View {
        self.background(UMBlur(material, blendingMode: blendingMode))
    }

    @inline(__always)
    func blur(
        _ material: Binding<NSVisualEffectView.Material>,
        blendingMode: Binding<NSVisualEffectView.BlendingMode>) -> some View {
        self.background(UMBlur(material, blendingMode: blendingMode))
    }
}

public extension UMBlur {
    static var systemMaterial: UMBlur {
        UMBlur(.appearanceBased, blendingMode: .withinWindow)
    }
}

#endif
