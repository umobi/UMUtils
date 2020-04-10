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

import RxSwift
import RxCocoa
import UIContainer

public extension Reactive where Base: ActivityView {

    var animating: AnyObserver<Bool> {
        return AnyObserver { event in
            MainScheduler.ensureExecutingOnScheduler()

            switch event {
            case .next(let value):
                if value {
                    guard !self.base.isAnimating else {
                        return
                    }

                    self.base.show(inView: UIApplication.shared.keyWindow)
                    return
                }

                guard self.base.isAnimating else {
                    return
                }

                self.base.hide()
            case .error(let error):
                let error = "Binding error to UI: \(error)"
                #if DEBUG
                    fatalError(error)
                #else
                    print(error)
                #endif
            case .completed:
                break
            }
        }
    }
}
