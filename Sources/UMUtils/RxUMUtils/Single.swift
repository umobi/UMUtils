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
import RxCocoa
import RxSwift

class SingleObservable<Element>: ObservableType {

    var disposeBag: DisposeBag! = .init()

    enum Payload {
        case output(Element)
        case failure(Error)
        case finished
        case empty
    }

    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    var payload: Payload = .empty
    var onValidPayload: ((Payload) -> Void)? = nil

    func disposeTheBag() {
        self.queue.addOperation {
            if self.disposeBag != nil {
                self.disposeBag = nil
            }
        }
    }

    private func send(_ value: Element) {
        guard case .empty = self.payload else {
            return
        }

        self.payload = .output(value)
        self.disposeTheBag()

        self.onValidPayload?(self.payload)
    }

    enum Completion {
        case failure(Error)
        case finished
    }

    private func send(completion: Completion) {
        guard case .empty = self.payload else {
            return
        }

        switch completion {
        case .failure(let failure):
            self.payload = .failure(failure)
        case .finished:
            self.payload = .finished
        }

        self.disposeTheBag()
        self.onValidPayload?(self.payload)
    }

    static func commit<O>(payload: Payload, observer: O) where O: ObserverType, Element == O.Element {
        switch payload {
        case .output(let output):
            observer.on(.next(output))
        case .failure(let failure):
            observer.on(.error(failure))
        case .finished:
            observer.on(.completed)
        case .empty:
            return
        }
    }

    func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, Element == Observer.Element {
        guard case .empty = self.payload else {
            Self.commit(payload: self.payload, observer: observer)

            return SingleDispose { [weak self] in
                self?.disposeTheBag()
            }
        }

        self.onValidPayload = {
            Self.commit(payload: $0, observer: observer)
        }

        return SingleDispose { [weak self] in
            self?.disposeTheBag()
        }
    }

    init(_ observable: Observable<Element>) {
        let disposable = observable
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {
                self.send($0)
            }, onError: {
                self.send(completion: .failure($0))
            }, onCompleted: {
                self.send(completion: .finished)
            }, onDisposed: {
                self.send(completion: .finished)
            })

        if case .empty = self.payload, let disposeBag = self.disposeBag {
            disposable.disposed(by: disposeBag)
            return
        }
    }
}

struct SingleDispose: Disposable {
    let handler: () -> Void

    init(_ handler: @escaping () -> Void) {
        self.handler = handler
    }

    func dispose() {
        self.handler()
    }
}

public extension ObservableType {
    func um_single() -> Observable<Element> {
        SingleObservable(self.asObservable())
            .asObservable()
    }
}
