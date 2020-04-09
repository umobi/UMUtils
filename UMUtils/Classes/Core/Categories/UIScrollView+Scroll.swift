//
//  UIScrollView+Scroll.swift
//  SPA at home
//
//  Created by Ramon Vicente on 15/04/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import UIKit

extension UIScrollView {
    open func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}
