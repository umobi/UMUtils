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

public typealias ActivityIndicatorFilter = (activityIndicator: ActivityIndicator, condition: Bool)

public extension ObservableConvertibleType {

  /// Filters the elements of an observable sequence based on an ActivityIndicator.
  ///
  ///     let loading = ActivityIndicator()
  ///     source
  ///         .filter(!loading)
  ///         .flatMap { ... }
  ///         .subscribe { ... }
  ///
func filter(_ activityIndicator: ActivityIndicator) -> Observable<Self.E> {
    return self.filter(activityIndicator == true)
  }

func filter(_ activityIndicatorFilter: ActivityIndicatorFilter) -> Observable<Self.E> {
    let (activityIndicator, condition) = activityIndicatorFilter
    return self.asObservable()
      .withLatestFrom(activityIndicator.asObservable().startWith(false)) { ($0, $1) }
      .filter { _, isLoading in
            isLoading == condition
        }
      .map { element, _ in element }
  }
}

// MARK: filter
extension SharedSequenceConvertibleType {

    public func filter(_ activityIndicator: ActivityIndicator) -> SharedSequence<DriverSharingStrategy, E> {
        return self.filter(activityIndicator == true)
    }

    public func filter(_ activityIndicatorFilter: ActivityIndicatorFilter) -> SharedSequence<DriverSharingStrategy, E> {
        let observable: Observable<Self.E> = self.filter(activityIndicatorFilter)
        return observable.asDriver(onErrorDriveWith: Driver.never())
    }
}

prefix operator !

public prefix func ! (activityIndicator: ActivityIndicator) -> ActivityIndicatorFilter {
  return activityIndicator == false
}

public prefix func ! (activityIndicatorFilter: ActivityIndicatorFilter) -> ActivityIndicatorFilter {
  return (activityIndicatorFilter.activityIndicator, !activityIndicatorFilter.condition)
}

func == (activityIndicator: ActivityIndicator, condition: Bool) -> ActivityIndicatorFilter {
  return (activityIndicator, condition)
}
