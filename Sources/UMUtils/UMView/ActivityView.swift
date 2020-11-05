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

import UIKit
import UICreator

public final class UMActivity: UICView {
    @Value private var timer: Timer? = nil

    @Relay private var isAnimating: Bool
    @Relay private var blurEffect: UIBlurEffect.Style
    @Relay private var color: UIColor

    private let contents: (() -> ViewCreator)?

    private let style: UIActivityIndicatorView.Style
    private let mode: Mode
    private let size: Size

    public init(
        _ blurEffect: Relay<UIBlurEffect.Style>,
        style: UIActivityIndicatorView.Style = .gray,
        color: Relay<UIColor>,
        size: Size = .medium,
        mode: Mode = .forever,
        isAnimating: Relay<Bool>,
        @UICViewBuilder contents: @escaping () -> ViewCreator) {

        self._blurEffect = blurEffect
        self._isAnimating = isAnimating
        self._color = color
        self.style = style
        self.size = size
        self.mode = mode
        self.contents = contents
    }

    public init(
        _ blurEffect: UIBlurEffect.Style,
        style: UIActivityIndicatorView.Style = .gray,
        color: UIColor,
        size: Size = .medium,
        mode: Mode = .forever,
        isAnimating: Relay<Bool>) {

        self._blurEffect = .constant(blurEffect)
        self._isAnimating = isAnimating
        self._color = .constant(color)
        self.style = style
        self.size = size
        self.mode = mode
        self.contents = nil
    }

    private func setInterruption(_ time: TimeInterval) {
        guard self.isAnimating else {
            return
        }

        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(
            withTimeInterval: time,
            repeats: false,
            block: { _ in self.isAnimating.toggle() }
        )
    }

    public var body: ViewCreator {
        UICCenter { [unowned self] in
            UICRounder(radius: 7.5) {
                UICZStack {
                    UICBlur(self.$blurEffect)

                    UICVScroll {
                        UICSpacer(spacing: 20 * size.factor) {
                            UICVStack {
                                UICActivity(.gray, isAnimating: self.$isAnimating)
                                    .transform(.init(scaleX: self.size.factor, y: self.size.factor))
                                    .color(self.$color)
                                    .onInTheScene { _ in
                                        guard case .until(let timeInterval) = self.mode else {
                                            return
                                        }

                                        self.$isAnimating.distinctSync {
                                            guard $0 else {
                                                self.killInterruption()
                                                return
                                            }

                                            self.setInterruption(timeInterval)
                                        }
                                    }

                                if let contents = self.contents {
                                    contents()
                                }
                            }
                        }
                    }
                }
            }
        }
        .isHidden(!self.$isAnimating)
        .shadowOffset(x: 1, y: 2)
        .shadowOcupacity(0.1)
        .shadowRadius(3)
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

extension UMActivity {

    private func killInterruption() {
        self.timer?.invalidate()
        self.timer = nil
    }
}

public extension UIViewCreator {
    @inlinable
    func activityIndicator(
        _ blurEffect: Relay<UIBlurEffect.Style>,
        style: UIActivityIndicatorView.Style = .gray,
        color: Relay<UIColor>,
        size: UMActivity.Size = .medium,
        mode: UMActivity.Mode = .forever,
        isAnimating: Relay<Bool>,
        @UICViewBuilder contents: @escaping () -> ViewCreator
    ) -> UICAnyView {

        UICAnyView(
            UICZStack {
                self.insets()

                UMActivity(
                    blurEffect, style: style,
                    color: color,
                    size: size,
                    mode: mode,
                    isAnimating: isAnimating,
                    contents: contents
                )
            }
        )
    }

    @inlinable
    func activityIndicator(
        _ blurEffect: UIBlurEffect.Style,
        style: UIActivityIndicatorView.Style = .gray,
        color: UIColor,
        size: UMActivity.Size = .medium,
        mode: UMActivity.Mode = .forever,
        isAnimating: Relay<Bool>
    ) -> UICAnyView {

        UICAnyView(
            UICZStack {
                self.insets()

                UMActivity(
                    blurEffect, style: style,
                    color: color,
                    size: size,
                    mode: mode,
                    isAnimating: isAnimating
                )
            }
        )
    }
}
