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
import RxCocoa
import RxSwift

private var kMaskTextField: UInt = 0
extension UITextField {
    var maskText: MaskTextField? {
        get { objc_getAssociatedObject(self, &kMaskTextField) as? MaskTextField }
        set { objc_setAssociatedObject(self, &kMaskTextField, newValue, .OBJC_ASSOCIATION_RETAIN)}
    }
}

public struct MaskTextField {
    private let mask: MaskType

    public init(mask: MaskType) {
        self.mask = mask
    }
    
    public func onTextField(_ textField: UITextField!) {
        textField.maskText = self

        textField.rx.text.startWith(textField.text)
            .subscribe(onNext: { [weak textField] text in
                let masked = text?.mask(self.mask)
                if masked != text {
                    textField?.text = masked
                }
            }).disposed(by: textField.disposeBag)
    }
}
