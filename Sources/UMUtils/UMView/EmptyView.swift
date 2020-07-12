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
import ConstraintBuilder
import UIContainer
import UICreator

@available(*, deprecated, message: "Use DZNEmptyDataSet")
public class EmptyView: UIView {
    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var messageLabel: UILabel!

    private weak var actionContainer: UIView!
    public private(set) weak var actionButton: UIButton!

    private weak var imageContainer: UIView!
    public private(set) weak var imageView: UIImageView!

    private weak var stackView: UIStackView!

    public init() {
        super.init(frame: .infinite)
        self.setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    private func setup() {
        self.prepareStackView()
        self.prepareImageView()
        self.prepareTitle()
        self.prepareMessage()
        self.prepareAction()

//        self.backgroundColor = .white

        self.stackView.arrangedSubviews.forEach {
            $0.isHidden = true
        }
    }
}

@objc
public extension EmptyView {

    func setTitle(_ title: String?) {
        self.titleLabel.text = title

        guard let title = title, !title.isEmpty else {
            self.titleLabel.isHidden = true
            return
        }

        self.titleLabel.isHidden = false
    }

    func setMessage(_ message: String?) {
        self.messageLabel.text = message

        guard let message = message, !message.isEmpty else {
            self.messageLabel.isHidden = true
            return
        }

        self.messageLabel.isHidden = false
    }
}

public extension EmptyView {

    func setImage(_ image: UIImage?) {
        self.imageView.image = image

        guard image != nil else {
            self.imageContainer.isHidden = true
            return
        }

        self.imageContainer.isHidden = false
    }

    struct Target {
        let sender: Any?
        let action: Selector
        let event: UIControl.Event

        public init(_ sender: Any?, action: Selector, for event: UIControl.Event) {
            self.sender = sender
            self.action = action
            self.event = event
        }
    }

    func setAction(_ title: String?, target: Target? = nil) {
        self.actionButton.setTitle(title, for: .normal)

        guard let title = title, !title.isEmpty else {
            Self.onTapObject[self] = nil
            self.actionButton.removeTarget(nil, action: nil, for: .allEvents)
            self.actionContainer.isHidden = true
            return
        }

        self.actionContainer.isHidden = false
        guard let target = target else {
            return
        }

        self.actionButton.removeTarget(nil, action: nil, for: .allEvents)
        self.actionButton.addTarget(target.sender, action: target.action, for: target.event)
    }

    @objc fileprivate func onTap() {
        Self.onTapObject[self]?.tap()
    }

    static private var onTapObject: ObjectAssociation<TapHandler> = .init(policy: .OBJC_ASSOCIATION_RETAIN)

    class TapHandler {
        private let handler: (() -> Void)?

        init(_ handler: (() -> Void)?) {
            self.handler = handler
        }

        func tap() {
            self.handler?()
        }
    }

    func setAction(_ title: String?, onTap: (() -> Void)? = nil) {
        Self.onTapObject[self] = .init(onTap)
        self.setAction(title, target: .init(self, action: #selector(self.onTap), for: .touchUpInside))
    }
}

fileprivate extension EmptyView {
    func prepareStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30

        let scroll = ScrollView(stackView, axis: .vertical)
        CBSubview(self).addSubview(scroll)
        self.stackView = stackView

        Constraintable.activate {
            scroll.cbuild
                .top
                .bottom
                .greaterThanOrEqualTo(50)

            scroll.cbuild
                .centerY
                .equalTo(self.cbuild.centerY)

            scroll.cbuild
                .leading
                .trailing
                .equalTo(50)
        }
    }
}

fileprivate extension EmptyView {
    func createImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "SPCameraPickerLocked"))

        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 3

        CBSubview(self.imageContainer).addSubview(imageView)

        return imageView
    }

    func prepareImageView() {
        let containerView = UIView()
        CBSubview(self.stackView).addArrangedSubview(containerView)
        self.imageContainer = containerView

        self.imageView = self.createImageView()

        Constraintable.activate {
            self.imageContainer.cbuild
                .height
                .equalTo(100)
        }

        Constraintable.activate {
            self.imageView.cbuild
                .width
                .height
                .equalTo(self.imageContainer.cbuild.height)

            self.imageView.cbuild
                .center
                .equalTo(self.imageContainer)
        }

        self.imageView.layer.cornerRadius = 50
    }
}

fileprivate extension EmptyView {
    func prepareTitle() {
        let title = UILabel()

        title.font = UIFont.boldSystemFont(ofSize: 24.0)
        title.textColor = .gray
        title.textAlignment = .center
        title.text = "Title content"
        title.numberOfLines = 0

        title.lockResizeLayout()

        CBSubview(self.stackView).addArrangedSubview(title)

        self.titleLabel = title
    }

    func prepareMessage() {
        let message = UILabel()

        message.font = UIFont.systemFont(ofSize: 16.0)
        message.textColor = .lightGray
        message.textAlignment = .center
        message.text = "Message content"
        message.numberOfLines = 0

        message.lockResizeLayout()

        CBSubview(self.stackView).addArrangedSubview(message)

        self.messageLabel = message
    }
}

fileprivate extension EmptyView {
    func createAction() -> UIButton {
        let button = UIButton()

        button.setTitle("Tentar Novamente", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)

        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)

        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5

        return button
    }

    func prepareAction() {
        let actionButton = self.createAction()
        self.actionButton = actionButton

        let containerView = UIView()
        CBSubview(self.stackView).addArrangedSubview(containerView)
        self.actionContainer = containerView

        Constraintable.activate {
            containerView.cbuild
                .height
                .equalTo(50)
                .priority(.defaultLow)
        }

        CBSubview(containerView).addSubview(actionButton)


        Constraintable.activate {
            actionButton.cbuild
                .width
                .equalTo(210)

            actionButton.cbuild
                .leading
                .trailing
                .greaterThanOrEqualTo(0)

            actionButton.cbuild
                .centerX
                .equalTo(containerView)

            actionButton.cbuild
                .top
                .bottom
                .equalTo(0)
        }
    }
}

fileprivate extension UIView {
    func lockResizeLayout() {
        self.setContentHuggingPriority(.required, for: .vertical)
        self.setContentHuggingPriority(.required, for: .horizontal)

        self.setContentCompressionResistancePriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}

extension EmptyView: EmptyPayload {
    public func apply(title: NSAttributedString) {
        self.setTitle(title.string)
        titleLabel.attributedText = title
    }

    public func apply(message: NSAttributedString) {
        self.setMessage(message.string)
        messageLabel.attributedText = message
    }

    public func apply(image: UIImage) {
        self.setImage(image)
    }

    public func button(title: String, onTap: @escaping () -> Void) {
        self.setAction(title, onTap: onTap)
    }

    public func prepareForReuse() {
        self.setTitle(nil)
        self.setMessage(nil)
        self.setImage(nil)
        self.setAction(nil, target: nil)
    }

}

public protocol EmptyPayload {
    func apply(title: NSAttributedString)
    func apply(message: NSAttributedString)
    func apply(image: UIImage)
    func button(title: String, onTap: @escaping () -> Void)

    func prepareForReuse()
}

private class Box: UIView {
    init(_ view: UIView) {
        super.init(frame: .zero)
        CBSubview(self).addSubview(view)

        Constraintable.activate {
            view.cbuild
                .edges
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class EmptyFactory<View: UIView & EmptyPayload> {
    class Payload {
        typealias Button = (title: String, onTap: () -> Void)
        var title: (() -> NSAttributedString?)?
        var message: (() -> NSAttributedString?)?
        var image: (() -> UIImage?)?
        var button: (() -> Button?)?
        var onLayout: ((View) -> Void)?
        var customView: (() -> UIView?)?
    }

    let payload: Payload = .init()

    public init(_ type: View.Type) {}

    public func apply(title: String) -> Self {
        self.payload.title = { .init(string: title) }
        return self
    }

    public func apply(message: String) -> Self {
        self.payload.message = { .init(string: message) }
        return self
    }

    public func apply(image: UIImage) -> Self {
        self.payload.image = { image }
        return self
    }

    public func button(title: String, onTap: (() -> Void)? = nil) -> Self {
        let onTap = onTap ?? {}
        self.payload.button = { (title, onTap) }
        return self
    }

    public func apply(titles: @escaping () -> NSAttributedString?) -> Self {
        self.payload.title = titles
        return self
    }

    public func apply(messages: @escaping () -> NSAttributedString?) -> Self {
        self.payload.message = messages
        return self
    }

    public func apply(images: @escaping () -> UIImage?) -> Self {
        self.payload.image = images
        return self
    }

    public func button(buttons: @escaping () -> (title: String, onTap: () -> Void)?) -> Self {
        self.payload.button = buttons
        return self
    }

    public func customView(views: @escaping () -> UIView?) -> Self {
        self.payload.customView = views
        return self
    }

    public func apply(title: NSAttributedString) -> Self {
        self.payload.title = { title }
        return self
    }

    public func apply(message: NSAttributedString) -> Self {
        self.payload.message = { message }
        return self
    }

    public func onLayout(_ handler : @escaping (View) -> Void) -> Self {
        self.payload.onLayout = handler
        return self
    }

    private func display(_ emptyView: View) {
        guard emptyView.superview != nil else {
            fatalError()
        }

        emptyView.subviews.first(where: { $0 is Box })?.removeFromSuperview()

        if let customView = self.payload.customView?() {
            let box = Box(customView)
            UIView.CBSubview(emptyView).addSubview(box)
            Constraintable.activate {
                box.cbuild
                    .edges
            }
        } else {
            if let title = self.payload.title?() {
                emptyView.apply(title: title)
            }

            if let message = self.payload.message?() {
                emptyView.apply(message: message)
            }

            if let image = self.payload.image?() {
                emptyView.apply(image: image)
            }

            if let button = self.payload.button?() {
                emptyView.button(title: button.title, onTap: button.onTap)
            }
        }

        self.payload.onLayout?(emptyView)
    }

    public func onView(_ view: UIView!, handler isEmpty: ((@escaping (Bool) -> Void) -> Void)? = nil) {
        if view.subviews.first(where: { $0 is Box }) != nil {
            return
        }

        let contentView: UIView! = {
            if view is UIScrollView {
                guard let superview = view.superview else {
                    fatalError()
                }

                return superview
            }

            return view
        }()

        let emptyView = View()
        let box = Box(ContentView(emptyView, contentMode: .center))
        UIView.CBSubview(contentView).addSubview(box)
        Constraintable.activate {
            box.cbuild
                .edges
                .equalTo(view)
        }

        isEmpty? { isEmpty in
            if isEmpty {
                emptyView.prepareForReuse()
                self.display(emptyView)
                box.isHidden = false
                return
            } else {
                box.isHidden = true
            }
        }
    }

    @available(*, deprecated, renamed: "onView")
    public func onTable(_ tableView: UITableView!, handler isEmpty: ((@escaping (Bool) -> Void) -> Void)? = nil) {
        self.onView(tableView, handler: isEmpty)
    }

    @available(*, deprecated, renamed: "onView")
    public func onCollection(_ collectionView: UICollectionView!, handler isEmpty: ((@escaping (Bool) -> Void) -> Void)? = nil) {
        self.onView(collectionView, handler: isEmpty)
    }
}
