//
//  Observable+ActivityIndicator.swift
//  SPA at home
//
//  Created by Ramon Vicente on 14/03/17.
//  Copyright © 2017 SPA at home. All rights reserved.
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
