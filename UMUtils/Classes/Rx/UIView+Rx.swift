//
//  UIView+Rx.swift
//  UMUtils
//
//  Created by brennobemoura on 20/04/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate extension UIView {
    @objc func onTap(_ sender: TapGesture) {
        sender.handler()
    }
}

public class TapGesture: UITapGestureRecognizer {
    let handler: () -> Void

    init(target: UIView!, action handler: @escaping () -> Void) {
        self.handler = handler
        super.init(target: target, action: #selector(target.onTap(_:)))
    }
}

public extension Reactive where Base: UIView {
    var tap: ControlEvent<Void> {
        let observer: PublishRelay<Void> = .init()
        self.base.addGestureRecognizer(TapGesture(target: self.base) {
            observer.accept(())
        })
        
        return ControlEvent(events: observer)
    }
}

public extension Reactive where Base: UIView {
    var layoutSubviews: Observable<Void> {
        return self.sentMessage(#selector(Base.layoutSubviews)).map { _ in Void() }
    }

    static func async(_ view: UIView, handler: @escaping () -> Void) {
        var disposeBag: DisposeBag! = DisposeBag()
        view.rx.layoutSubviews.first().asObservable().do(onNext: { _ in
            OperationQueue.main.addOperation {
                handler()
                disposeBag = nil
            }
        }).subscribe().disposed(by: disposeBag)
    }

    var traitCollectionDidChange: Observable<Void> {
        return self.sentMessage(#selector(Base.traitCollectionDidChange(_:))).map { _ in return Void() }
    }

    var dynamicBorderColor: Observable<UIColor?> {
        return self.sentMessage(#selector(setter: Base.dynamicBorderColor)).map { $0.first as? UIColor }
    }

    internal func setBorderColor(_ color: UIColor?) {
        var disposeBag: DisposeBag? = DisposeBag()

        self.traitCollectionDidChange.subscribe(onNext: { [weak base] _ in
            base?.layer.borderColor = base?.dynamicBorderColor?.cgColor
        }).disposed(by: disposeBag ?? .init())

        Observable.merge(self.deallocating, self.dynamicBorderColor.flatMapLatest { e -> Observable<Void> in e == nil ? .just(()) : .never() }).subscribe(onNext: { _ in
            disposeBag = nil
        }).disposed(by: disposeBag ?? .init())
    }
}

public extension UIView {
    private static let borderColorAssociation = ObjectAssociation<UIColor>()

    @objc var dynamicBorderColor: UIColor? {
        get { return UIView.borderColorAssociation[self] }
        set {
            if self.dynamicBorderColor == nil {
                self.rx.setBorderColor(newValue)
            }

            UIView.borderColorAssociation[self] = newValue
            self.layer.borderColor = newValue?.cgColor
        }
    }
}
