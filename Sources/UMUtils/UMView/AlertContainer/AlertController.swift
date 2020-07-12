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
import UIContainer
import ConstraintBuilder
import UICreator

private var kViewController = 0
extension AlertView: ContainerViewParent {
    public var parent: UIViewController! {
        get { objc_getAssociatedObject(self, &kViewController) as? UIViewController }
        set { objc_setAssociatedObject(self, &kViewController, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
}

extension AlertView {
    class Container: ContainerView<AlertView> {
        override func loadView<T>(_ view: T) -> CBView where T : CBView {
            let contentView = UIView()

            if #available(iOS 11.0, *) {
                contentView.insetsLayoutMarginsFromSafeArea = true
            }

            if let fadeView = self.view.fadeView {
                CBSubview(contentView).addSubview(fadeView)

                Constraintable.activate {
                    fadeView.cbuild
                        .edges
                }
            }

            if self.view.useBlur {
                let blurView = BlurView(blur: self.view.blurEffectStyle)
                CBSubview(contentView).addSubview(blurView)

                Constraintable.activate {
                    blurView.cbuild
                        .edges
                }
            }

            let centerView = ContentView(
                RounderView(view, radius: view.layer.cornerRadius),
                contentMode: .center
            )

            CBSubview(contentView).addSubview(centerView)

            Constraintable.activate {
                centerView.cbuild
                    .top
                    .equalTo(contentView.cbuild.topMargin)

                centerView.cbuild
                    .bottom
                    .equalTo(contentView.cbuild.bottomMargin)

                centerView.cbuild
                    .leading
                    .trailing
                    .equalTo(0)
            }

            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnBackground))
            contentView.addGestureRecognizer(tap)

            return contentView
        }
        
        @objc func tapOnBackground() {
            guard self.view.actions.isEmpty else {
                return
            }
            
            self.parent.dismiss(animated: true, completion: nil)
        }

        override func containerDidLoad() {
            super.containerDidLoad()

            if #available(iOS 11.0, *) {
                self.insetsLayoutMarginsFromSafeArea = true
            }
        }
    }
}

extension AlertView: ViewControllerType {
    public var content: ViewControllerMaker {
        .dynamic {
            let containerView = AlertView.Container.init(in: $0, loadHandler: { self })
            CBSubview($0.view).addSubview(containerView)

            Constraintable.activate {
                containerView.cbuild
                    .edges
            }
        }
    }
    
    @objc func tapOnBackground() {
        guard !self.actions.isEmpty else {
            return
        }
        
        self.parent.dismiss(animated: true, completion: nil)
    }
}
