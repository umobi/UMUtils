//
//  UIView+Corner.swift
//  SpaAtHome
//
//  Created by Ramon Vicente on 07/08/17.
//  Copyright © 2017 Spa At Home. All rights reserved.
//

import UIKit

extension UIView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    @IBInspectable
    open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set(value) {
            layer.cornerRadius = value
        }
    }
    
}
