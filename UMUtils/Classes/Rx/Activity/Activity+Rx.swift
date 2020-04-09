//
//  Activity+Rx.swift
//  Pods-UMUtils_Tests
//
//  Created by brennobemoura on 10/11/19.
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
