//
//  MaskTextField.swift
//  mercadoon
//
//  Created by brennobemoura on 23/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
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
            .subscribe(onNext: { [weak textField, mask] text in
                let masked = text?.mask(self.mask)
                if masked != text {
                    textField?.text = masked
                }
            }).disposed(by: textField.disposeBag)
    }
}
