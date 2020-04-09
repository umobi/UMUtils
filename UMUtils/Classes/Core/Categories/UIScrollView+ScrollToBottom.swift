//
//  UIScrollView+ScrollToBottom.swift
//  SPA at home
//
//  Created by Suyeol Jeon on 16/02/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

extension UIScrollView {

  var isOverflowVertical: Bool {
    return self.contentSize.height > self.frame.height && self.frame.height > 0
  }

  func isReachedBottom(withTolerance tolerance: CGFloat = 0) -> Bool {
    guard self.isOverflowVertical else { return false }
    let contentOffsetBottom = self.contentOffset.y + self.frame.height
    return contentOffsetBottom >= self.contentSize.height - tolerance
  }

  func scrollToBottom(animated: Bool) {
    guard self.isOverflowVertical else { return }
    let targetY = self.contentSize.height + self.contentInset.bottom - self.frame.height
    let targetOffset = CGPoint(x: 0, y: targetY)
    self.setContentOffset(targetOffset, animated: true)
  }

}
