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
import UIKit

extension UIButton {
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
