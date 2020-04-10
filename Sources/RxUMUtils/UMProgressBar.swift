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
import RxCocoa
import RxSwift

#if !COCOAPODS
import UMUtils
#endif

public enum UMProgressBarPosition {
    case top
    case bottom
}

open class UMProgressBar: UIView {

    open var indicatorColor: UIColor = .black
    open var indicatorHeight: CGFloat = 3
    open var indicatorWidth: CGFloat = 60

    open var barPosition: UMProgressBarPosition = .top

    open var positionOffset: UIEdgeInsets = .zero

    fileprivate var isAnimating = false
    fileprivate var indicatorView: UIView!
    fileprivate var targetView: UIView!

    public init(view: UIView) {
        super.init(frame: .zero)
        self.targetView = view
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        self.indicatorView = UIView(frame: CGRect(x: -indicatorWidth, y: 0,
                                                  width: indicatorWidth,
                                                  height: indicatorHeight))
        self.addSubview(self.indicatorView)
        self.backgroundColor = .clear
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        guard let superview = self.superview else { return }
        let width = superview.frame.width - positionOffset.left - positionOffset.right
        let x = positionOffset.left
        let y = self.barPosition == .top ? positionOffset.top : superview.frame.height - indicatorHeight - positionOffset.bottom
        self.frame.size = CGSize(width: width, height: indicatorHeight)
        self.frame.origin = CGPoint(x: x, y: y)
        superview.bringSubviewToFront(self)
    }
}

extension UMProgressBar {

    open func start() {

        if self.superview == nil {
            self.targetView.addSubview(self)
        }

        self.setNeedsLayout()

        if !self.isAnimating {
            self.isAnimating = true
            self.indicatorView.transform = .identity
            self.indicatorView.backgroundColor = self.indicatorColor
            self.alpha = 0

            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1
            }, completion: { _ in
                self.animate(false)
            })
        }
    }

    open class func stop(for view: UIView) {
        if let progressBars = view.subviews.filter({ view -> Bool in
            return view is UMProgressBar
        }) as? [UMProgressBar], progressBars.count > 0 {
            progressBars.forEach {
                $0.stop()
            }
        }
    }

    open func stop() {

        self.isAnimating = false

        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }

    fileprivate func animate(_ inverse: Bool) {

        guard let superview = self.superview else {
            return
        }

        if !inverse {
            self.indicatorView.transform = .identity
        } else {
            self.indicatorView.transform = CGAffineTransform(translationX: superview.frame.width + self.indicatorWidth, y: 0)
        }

        let animateOption = UIView.KeyframeAnimationOptions(rawValue: UIView.AnimationOptions.curveEaseInOut.rawValue)

        UIView.animateKeyframes(withDuration: 1.0,
                                delay: 0.2,
                                options: [.calculationModePaced, animateOption], animations: {

                                    if !inverse {
                                        UIView.addKeyframe(withRelativeStartTime: 0,
                                                           relativeDuration: 1.0,
                                                           animations: {
                                                            self.indicatorView.transform = CGAffineTransform(translationX: superview.frame.width + self.indicatorWidth,
                                                                                                             y: 0)
                                        })
                                    } else {
                                        UIView.addKeyframe(withRelativeStartTime: 0,
                                                           relativeDuration: 1.0,
                                                           animations: {
                                                            self.indicatorView.transform = .identity
                                        })
                                    }

        }) { _ in
            if self.isAnimating {
                self.animate(!inverse)
            }
        }
    }
}

extension Reactive where Base: UMProgressBar {

    public var animating: AnyObserver<Bool> {
        return AnyObserver {event in
            MainScheduler.ensureExecutingOnScheduler()

            switch event {
            case .next(let value):
                if self.base.targetView == nil {
                    self.base.targetView = UIApplication.shared.windows.first!
                }

                if self.base.targetView != nil {

                    if value {
                        let localBar = UMProgressBar(view: self.base.targetView)
                        localBar.barPosition = self.base.barPosition
                        localBar.positionOffset = self.base.positionOffset
                        localBar.indicatorColor = self.base.indicatorColor
                        localBar.indicatorHeight = self.base.indicatorHeight
                        localBar.indicatorWidth = self.base.indicatorWidth
                        localBar.start()
                    } else {
                        UMProgressBar.stop(for: self.base.targetView)
                    }
                }
            case .error(let error):
                let error = "Binding error to UI: \(error)"
                #if DEBUG
                    fatalError(error)
                #else
                    print(error)
                #endif
            case .completed:
                break
            }
        }
    }
}

extension UMProgressBar {

    // swiftlint:disable identifier_name
    @nonobjc
    public static var rx: Reactive<UMProgressBar>.Type {
        get {
            return Reactive<UMProgressBar>.self
        }
        set {
            // this enables using Reactive to "mutate" base type
        }
    }
}
