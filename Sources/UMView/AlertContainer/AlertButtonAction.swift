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

#if !COCOAPODS
import UMUtils
#endif

extension AlertButton {
    open class Action {
        let title: String?
        let handler: ((Action) -> Void)?
        public let style: UIAlertAction.Style

        required public init(title: String?, handler: ((Action) -> Void)? = nil, style: UIAlertAction.Style? = nil) {
            self.title = title
            self.handler = handler
            self.style = style ?? .default
        }

        open func asView() -> UIView {
            let button = AlertButton(frame: .zero)

            button.setTitle(self.title, for: .normal)

            switch self.style {
            case .cancel:
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .black
                button.layer.borderColor = UIColor.black.cgColor
            default:
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .white
                button.layer.borderColor = UIColor.black.cgColor
            }

            button.setTitleColor(button.titleColor(for: .normal)?.withAlphaComponent(0.5), for: .highlighted)
            button.layer.borderWidth = 1
            button.addAction(self)
            
            return button
        }
    }
}
