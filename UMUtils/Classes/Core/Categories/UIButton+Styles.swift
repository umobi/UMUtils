//
//  UIButton+Styles.swift
//  SPA at home
//
//  Created by Ramon Vicente on 19/03/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    override open var isEnabled: Bool {
        didSet {
//            alpha = isEnabled ? 1: 0.7
        }
    }

    open func centerVertically(padding: CGFloat = 6.0, imagePosition: UIView.ContentMode = .top) {
        guard let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size  else { return }

        let buttonSize = self.frame.size

        let totalHeight = imageViewSize.height + titleLabelSize.height + padding

        var titleEdgeInsets = UIEdgeInsets.zero
        var imageEdgeInsets = UIEdgeInsets.zero
        var contentEdgeInsets = UIEdgeInsets.zero

        if imagePosition == .top {
            imageEdgeInsets.top = -(totalHeight - imageViewSize.height)
            imageEdgeInsets.right = -titleLabelSize.width

            titleEdgeInsets.left = -imageViewSize.width
            titleEdgeInsets.bottom = -(totalHeight - titleLabelSize.height)
        } else if imagePosition == .bottom {

            imageEdgeInsets.bottom = -(totalHeight - imageViewSize.height)
            imageEdgeInsets.right = -titleLabelSize.width

            titleEdgeInsets.left = -imageViewSize.width
            titleEdgeInsets.top = -(totalHeight - titleLabelSize.height)
        }

        contentEdgeInsets.top = (totalHeight - buttonSize.height)/2
        contentEdgeInsets.bottom = (totalHeight - buttonSize.height)/2

        self.imageEdgeInsets = imageEdgeInsets
        self.titleEdgeInsets = titleEdgeInsets
        self.contentEdgeInsets = contentEdgeInsets

        self.invalidateIntrinsicContentSize()
    }
}
