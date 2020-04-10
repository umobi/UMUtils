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

import UIKit

import RxCocoa
import RxSwift

public extension Reactive where Base: UIViewController {

  var viewDidLoad: Observable<Void> {
    return self.sentMessage(#selector(Base.viewDidLoad)).map { _ in Void() }
  }

  var viewWillAppear: Observable<Bool> {
    return self.sentMessage(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
  }
  var viewDidAppear: Observable<Bool> {
    return self.sentMessage(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
  }

  var viewWillDisappear: Observable<Bool> {
    return self.sentMessage(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
  }
  var viewDidDisappear: Observable<Bool> {
    return self.sentMessage(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
  }

  var viewWillLayoutSubviews: Observable<Void> {
    return self.sentMessage(#selector(Base.viewWillLayoutSubviews)).map { _ in Void() }
  }
  var viewDidLayoutSubviews: Observable<Void> {
    return self.sentMessage(#selector(Base.viewDidLayoutSubviews)).map { _ in Void() }
  }

}
