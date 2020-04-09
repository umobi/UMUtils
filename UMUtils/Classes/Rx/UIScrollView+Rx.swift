//
//  UIScrollView+Rx.swift
//  UMUtils
//
//  Created by brennobemoura on 09/11/19.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: UIScrollView {
    var reachedBottom: ControlEvent<Void> {
        let observable = contentOffset
            .flatMap { [weak base] contentOffset -> Observable<Void> in
                guard let scrollView = base else {
                    return Observable.empty()
                }

                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let verticalPosition = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)

                return verticalPosition > threshold ? Observable.just(()): Observable.empty()
        }

        return ControlEvent(events: observable)
    }
}
