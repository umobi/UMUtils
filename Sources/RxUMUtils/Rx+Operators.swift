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

import RxCocoa
import RxSwift

#if !COCOAPODS
import UMUtils
#endif

// MARK: - isSucceeded()

extension ObservableType {
  public func isSucceeded() -> Observable<Bool> {
    return self.map(true).catchErrorJustReturn(false)
  }
}


// MARK: - map()

extension ObservableType {
  public func map<T>(_ element: T) -> Observable<T> {
    return self.map { _ in element }
  }
}

extension SharedSequence {
  public func map<T>(_ element: T) -> SharedSequence<SharingStrategy, T> {
    return self.map { _ in element }
  }
}


// MARK: - mapVoid()

extension ObservableType {
  public func mapVoid() -> Observable<Void> {
    return self.map(Void())
  }
}

extension ObservableType {
    public func asFunction(_ disposeBag: DisposeBag) -> (@escaping (Element) -> Void) -> Void  {
        return { handler in
            self.subscribe(onNext: {
                handler($0)
            }).disposed(by: disposeBag)
        }
  }
}

extension SharedSequence {
  public func mapVoid() -> SharedSequence<SharingStrategy, Void> {
    return self.map(Void())
  }
}

extension SharedSequence where SharingStrategy == DriverSharingStrategy {
    public func asFunction(_ disposeBag: DisposeBag) -> (@escaping (Element) -> Void) -> Void  {
          return { handler in
              self.drive(onNext: {
                  handler($0)
              }).disposed(by: disposeBag)
          }
    }
}


// MARK: - ignoreErrors()

extension ObservableType {
  public func ignoreErrors() -> Observable<Element> {
    return self.catchError { error -> Observable<Element> in
      return .empty()
    }
  }
}



infix operator <->

@available(*, deprecated, message: "Use BehaviorRelay instead")
@discardableResult public func <-><T>(property: ControlProperty<T>, variable: Variable<T>) -> Disposable {
    let variableToProperty = variable.asObservable()
        .bind(to: property)

    let propertyToVariable = property
        .subscribe(
            onNext: { variable.value = $0 },
            onCompleted: { variableToProperty.dispose() }
    )

    return Disposables.create(variableToProperty, propertyToVariable)
}


@discardableResult public func <-><T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    let relayToProperty = relay.asObservable()
        .bind(to: property)

    let propertyToRelay = property.asObservable()
        .bind(to: relay)

    return Disposables.create(relayToProperty, propertyToRelay)
}
