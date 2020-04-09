//
//  UIView+Border.swift
//  Umobi
//
//  Created by Ramon Vicente on 16/03/17.
//  Copyright © 2017 Umobi. All rights reserved.
//

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
