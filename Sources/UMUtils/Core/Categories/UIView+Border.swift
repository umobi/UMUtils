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

#if os(iOS) || os(tvOS)
import UIKit

extension UIView {

    public enum ViewSide {
        case top
        case right
        case bottom
        case left
    }

    @IBInspectable
    open var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set(value) {
            layer.borderWidth = value
        }
    }

    @IBInspectable
    open var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set(value) {
            layer.shadowOffset = value
        }
    }

    @IBInspectable
    open var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set(value) {
            layer.shadowOpacity = value
        }
    }

    @IBInspectable
    open var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set(value) {
            layer.shadowRadius = value
        }
    }

    @IBInspectable
    open var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set(value) {
            layer.shadowPath = value
        }
    }
}

extension UIView {

    public func addBorder(side: ViewSide,
                          thickness: CGFloat,
                          color: UIColor,
                          offset: UIEdgeInsets = .zero) {

        let border: UIView!
        switch side {
        case .top:
            border = _getViewBackedOneSidedBorder(frame: CGRect(x: offset.left,
                                                                y: offset.top,
                                                                width: self.frame.size.width - offset.left - offset.right,
                                                                height: thickness),
                                                  color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]

            break
        case .right:
            border = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width - thickness - offset.right,
                                                                y: 0 + offset.top, width: thickness,
                                                                height: self.frame.size.height - offset.top - offset.bottom),
                                                  color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]

            break
        case .bottom:
            border = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + offset.left,
                                                                y: self.frame.size.height - thickness - offset.bottom,
                                                                width: self.frame.size.width - offset.left - offset.right,
                                                                height: thickness),
                                                  color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]

            break
        case .left:
            border = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + offset.left,
                                                                y: offset.top,
                                                                width: thickness,
                                                                height: self.frame.size.height - offset.top - offset.bottom),
                                                  color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]

            break
        }

        self.addSubview(border)
    }

    fileprivate func _getViewBackedOneSidedBorder(frame: CGRect, color: UIColor) -> UIView {
        let border = UIView(frame: frame)
        border.backgroundColor = color
        return border
    }
}
#endif
