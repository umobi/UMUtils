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

#if !COCOAPODS
import UMCore
#endif

private var kTextFieldDisposeBag: UInt = 0
extension UITextField {
    var disposeBag: DisposeBag {
        guard let disposeBag = objc_getAssociatedObject(self, &kTextFieldDisposeBag) as? DisposeBag else {
            let disposeBag = DisposeBag()
            objc_setAssociatedObject(self, &kTextFieldDisposeBag, disposeBag, .OBJC_ASSOCIATION_RETAIN)
            return disposeBag
        }

        return disposeBag
    }
}

private var kNextTextField: UInt = 0
extension UITextField {
    var nextText: NextTextField? {
        get { objc_getAssociatedObject(self, &kNextTextField) as? NextTextField }
        set { objc_setAssociatedObject(self, &kNextTextField, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

public class NextTextField {

    private weak var prev: NextTextField?
    private weak var next: NextTextField?
    private let isOptional: Bool

    private weak var field: UITextField!
    private weak var button: UIButton!
    
    fileprivate init(_ field: UITextField!,_ isOptional: Bool, previous: NextTextField? = nil) {
        self.field = field
        self.prev = previous
        self.isOptional = isOptional
        self.startListening()
    }
    
    @discardableResult
    public func onNext(_ field: UITextField!, isOptional: Bool = false) -> NextTextField {
        let next = NextTextField(field, isOptional, previous: self)
        self.next = next
        return next
    }

    private func startListening() {
        self.field.nextText = self
        self.field?.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] _ in
                self?.nextOrHit()
            }).disposed(by: self.field.disposeBag)
    }
    
    public static func start(_ field: UITextField, isOptional: Bool = false) -> NextTextField {
        return Root(field, isOptional)
    }

    private func becomeFirstResponder() {
        if !self.isAvailable {
            self.nextOrHit()
            return
        }
        
        self.field.becomeFirstResponder() ? () : self.nextOrHit()
    }

    @objc private func nextOrHit() {
        if let next = self.next {
            next.becomeFirstResponder()
            return
        }

        guard !self.hitIfNeeded() else  {
            return
        }

        self.root?.nextAvailable?.field?.becomeFirstResponder()
    }

    private static func root(in ref: NextTextField!) -> NextTextField.Root? {
        guard let ref = ref else {
            return nil
        }

        if let root = ref as? Root {
            return root
        }

        return Self.root(in: ref.prev)
    }

    private var root: NextTextField.Root? {
        return Self.root(in: self)
    }

    var isAvailable: Bool {
        return self.field?.text?.isEmpty ?? false
    }

    private func hitIfNeeded() -> Bool {
        guard let root = self.root else {
            return false
        }

        let canHit: Bool = {
            var root: NextTextField? = root
            while let next = root {
                if !next.isOptional && (next.isAvailable) {
                    return false
                }

                root = next.next
            }

            return true
        }()

        if canHit {
            self.root?.hitButton?.sendActions(for: .touchUpInside)
            return true
        }

        return false
    }

    public func andHit(on button: UIButton!) {
        self.button = button
    }
}

extension NextTextField {
    class Root: NextTextField {
        var hitButton: UIButton? {
            var ref: NextTextField? = self
            while let next = ref {
                if let button = next.button {
                    return button
                }

                ref = next.next
            }

            return nil
        }

        var nextAvailable: NextTextField? {
            var ref: NextTextField? = self
            while let next = ref {
                if next.isAvailable {
                    return next
                }

                ref = next.next
            }

            return nil
        }
    }
}
