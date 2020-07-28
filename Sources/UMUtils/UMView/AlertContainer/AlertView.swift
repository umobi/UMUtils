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
import ConstraintBuilder
import UICreator
import UIKit

open class AlertView: UIView {
    private var contentSV: UIStackView!
    private var stackView: UIStackView!
    private weak var spacer: UICSpacer.View!
    
    // MARK: Image Alert
    public private(set) var imageView: UIImageView? = nil

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }

    open var imageHeight: CGFloat = 175 {
        willSet {
            if imageView != nil {
                self.updateHeight(self.imageView, height: newValue)
            }
        }
    }
    
    public func updateHeight(_ view: UIView!, height: CGFloat) {
        guard let superview = view.superview else {
            return
        }

        Constraintable.update {
            view.cbuild
                .height
                .equalTo(superview)
                .update()
                .constant(height)
        }
    }
    
    open func createImage(_ image: UIImage) -> UIImageView {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.image = image
        return imgView
    }

    public func setImage(_ image: UIImage?) {
        guard let image = image else {
            self.imageView?.removeFromSuperview()
            self.imageView = nil
            return
        }

        if self.imageView == nil {
            self.imageView = self.createImage(image)
            self.updateHeight(self.imageView, height: self.imageHeight)
        } else {
            self.imageView?.image = image
        }

        CBSubview(self.contentSV).insertArrangedSubview(self.imageView!, at: 0)
    }
    
    // MARK: Alert Title
    public private(set) var titleLabel: UILabel? = nil

    open func createTitle() -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.minimumScaleFactor = 0.65
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }

    public func setTitle(_ text: String?) {
        guard let text = text else {
            self.titleLabel?.removeFromSuperview()
            self.titleLabel = nil
            return
        }

        if self.titleLabel == nil {
            self.titleLabel = self.createTitle()
        }

        self.titleLabel?.text = text

        CBSubview(self.contentSV).insertArrangedSubview(self.titleLabel!, at: self.position(for: 1))
    }
    
    // MARK: Alert Subtitle
    private(set) var textSV: UIStackView? = nil

    open func createTextSV() -> UIStackView {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }
    
    open func createText() -> UILabel {
        let lbl = UILabel()
        lbl.minimumScaleFactor = 0.65
        lbl.textColor = UIColor(red: 0.51, green: 0.54, blue: 0.58, alpha: 1.00)
        lbl.textColor = .gray
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }
    
    public func setText(_ text: String?, at index: Int? = nil) {
        guard let text = text else {
            self.textSV?.removeFromSuperview()
            self.textSV = nil
            return
        }
        
        let stackView = self.textSV ?? self.createTextSV()
        let label: UILabel = {
            if let index = index, let label = stackView.arrangedSubviews[index] as? UILabel {
                return label
            }
            
            return self.createText()
        }()
        
        self.textSV = stackView
        
        if let attributed = label.attributedText {
            label.attributedText = attributed
        } else {
            label.text = text
        }
        
        if label.superview == nil {
            CBSubview(stackView).insertArrangedSubview(label, at: stackView.subviews.count)
        }
        
        if stackView.superview == nil {
            CBSubview(self.contentSV).insertArrangedSubview(stackView, at: self.position(for: 3))
        }
    }
    
    public final var textLabels: [UILabel] {
        return self.textSV?.arrangedSubviews.compactMap {
            $0 as? UILabel
        } ?? []
    }

    // MARK: Alert Text
    public private(set) var subtitleLabel: UILabel? = nil

    open func createSubtitle() -> UILabel {
        let lbl = UILabel()
        lbl.minimumScaleFactor = 0.65
        lbl.textColor = .lightGray
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }
    
    public func setSubtitle(_ text: String?) {
        guard let text = text else {
            self.subtitleLabel?.removeFromSuperview()
            self.subtitleLabel = nil
            return
        }

        if self.subtitleLabel == nil {
            self.subtitleLabel = self.createText()
        }

        self.subtitleLabel?.text = text

        CBSubview(self.contentSV).insertArrangedSubview(self.subtitleLabel!, at: self.position(for: 2))
    }

    // MARK: Position calculate the index for alertContainer
    private func position(for item: Int) -> Int {
        let array = [Any?]([
            self.imageView,
            self.titleLabel,
            self.subtitleLabel,
            self.textSV,
            self.actionSV
        ])

        let futureIndex = Array(array[0..<item]).reduce(0) { $0 + ($1 != nil ? 1 : 0) }
        return futureIndex >= self.stackView.arrangedSubviews.count ? self.stackView.arrangedSubviews.count : futureIndex
    }
    
    private let actionSV: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    public var actions: [UIView] {
        return self.stackView.arrangedSubviews
    }

    open func addAction(action: AlertButton.Action) {
        if actionSV.superview == nil {
            CBSubview(self.stackView).addArrangedSubview(actionSV)
        }
        
        let view = action.asView()
        
        if let tapGesture = view.gestureRecognizers?.first(where: { $0 is UITapGestureRecognizer }) as? UITapGestureRecognizer {
            tapGesture.addTarget(self, action: #selector(self.tapOnAction(_:)))
        } else {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapOnAction(_:)))
            view.addGestureRecognizer(tapGesture)
        }

        CBSubview(actionSV).insertArrangedSubview(self.rounder(actionView: view), at: 0)
    }
    
    open func rounder(actionView: UIView) -> UICRounder.View {
        return UICRounder.View(actionView, radius: 4)
            .border(color: {
                guard let cgColor = actionView.layer.borderColor else {
                    return nil
                }

                return UIColor(cgColor: cgColor)
            }())
            .border(width: actionView.layer.borderWidth)
    }

    @objc
    private func tapOnAction(_ sender: UIButton) {
        (sequence(first: self, next: { $0.next })
            .first(where: { $0 is UIViewController }) as? UIViewController)?
            .dismiss(animated: true, completion: nil)
    }
    
    open func prepare() {
        let content = UIStackView()
        let stack = UIStackView()
        let spacer = UICSpacer.View(stack, margin: .init(spacing: self.margin))

        self.contentSV = content
        self.stackView = stack
        self.spacer = spacer

        [stack, content].forEach {
            $0.axis = .vertical
            $0.spacing = self.spacing
        }

        let scrollView = UICScroll.View(content, axis: .vertical)
        CBSubview(self.stackView).addArrangedSubview(scrollView)
        CBSubview(self).addSubview(spacer)

        Constraintable.activate {
            spacer.cbuild
                .edges

            content.cbuild
                .height
                .equalTo(scrollView)
                .priority(.init(500))
        }
        
        self.applyWidth()
        
    }
    
    open var spacing: CGFloat {
        return 16
    }
    
    open var margin: CGFloat {
        return spacing * 2
    }
    
    open var fadeView: UIView! {
        if self.useBlur {
            return nil
        }
        
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        return view
    }

    // MARK: Width configuration for flexible layout
    private class var defaultWidth: CGFloat {
        return 290
    }
    
    open var alertWidth: CGFloat = defaultWidth
    
    private final func applyWidth() {
        Constraintable.activate {
            self.spacer.cbuild
                .width
                .equalTo(alertWidth)
        }
    }
    
    open var actionButtonType: AlertButton.Action.Type {
        return AlertButton.Action.self
    }
    
    open var blurEffectStyle: UIBlurEffect.Style = .regular
    
    open var useBlur: Bool = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.applyPriorities()
    }
    
    func applyPriorities() {
        [self.titleLabel, self.subtitleLabel].forEach {
            $0?.applyHighPriority()
        }
        
        self.textSV?.arrangedSubviews.forEach {
            $0.applyHighPriority()
        }
    }
    
    override public var backgroundColor: UIColor? {
        get {
            return self.spacer.backgroundColor
        }
        
        set {
            self.spacer.backgroundColor = newValue
        }
    }
}

fileprivate extension UIView {
    func applyHighPriority() {
        self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        self.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
}