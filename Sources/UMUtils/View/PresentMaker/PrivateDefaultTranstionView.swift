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

import SwiftUI

#if os(iOS) || os(tvOS)
import UIKit

class PrivateDefaultTranstionView: UIView {
    var isPresenting: Bool = false
}

struct DefaultTransitionViewWrapper: UIViewRepresentable {
    @Binding var isPresented: Bool
    let presentMaker: PresentMaker

    init(isPresented: Binding<Bool>, presentMaker: @escaping (PresentMaker) -> PresentMaker) {
        self._isPresented = isPresented
        self.presentMaker = presentMaker(PresentMaker())
    }

    func makeUIView(context: Context) -> PrivateDefaultTranstionView {
        PrivateDefaultTranstionView()
    }

    func updateUIView(_ uiView: PrivateDefaultTranstionView, context: Context) {
        if !self.isPresented {
            if uiView.isPresenting {
                uiView.isPresenting = false

                uiView.viewController.presentedViewController?
                    .dismiss(animated: self.presentMaker.animated, completion: nil)
            }

            return
        }

        guard let viewController = uiView.viewController else {
            fatalError()
        }

        uiView.isPresenting = true

        viewController.present(self.presentMaker.viewController(onDismiss: { [weak uiView] in
            if self.isPresented {
                self.isPresented = false
                uiView?.isPresenting = false
            }
        }), animated: self.presentMaker.animated, completion: self.presentMaker.onCompletion)

    }
}

extension UIView {
    var viewController: UIViewController! {
        sequence(first: self as UIResponder, next: { $0.next })
            .first(where: { $0 is UIViewController })
            as? UIViewController
    }
}
#endif
