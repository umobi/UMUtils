//
//  PagedProtocol.swift
//  mercadoon
//
//  Created by brennobemoura on 27/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public protocol MetaPageElement {
    associatedtype Index
    var indexPath: IndexPath { get }
    static func map(_ elements: [Index], startingAt indexPath: IndexPath) -> [Self]
}

public protocol MetaPageModel: class {
    associatedtype Model: MetaPageElement
    var itemsRelay: BehaviorRelay<[Model]> { get }
    
    var didReachEndOfRows: PublishRelay<Void> { get }
    var pageRelay: BehaviorRelay<MetaPage> { get }
    
    var reloadDriver: Driver<Void> { get }
    var refreshPageRelay: PublishRelay<MetaPage>? { get }
}

public extension MetaPageModel {
    var refreshPageRelay: PublishRelay<MetaPage>? {
        return nil
    }
    
    var reloadDriver: Driver<Void> {
        return .never()
    }
    
    var refreshDriver: Driver<MetaPage> {
        return Driver.merge(
            self.reloadDriver.startWith(()).map { .empty },
            self.continueLoadingPageDriver,
            self.refreshPageRelay?.asDriver(onErrorDriveWith: .never()) ?? .never()
        )
    }
    
    private var continueLoadingPageDriver: Driver<MetaPage> {
        return self.didReachEndOfRows
            .asDriver(onErrorJustReturn: ())
            .withLatestFrom(self.pageRelay.asDriver())
            .filter { $0.status == .next }
            .do(onNext: { [weak self] _ in
                self?.pageRelay.accept(self!.pageRelay.value.lock)
            })
    }
    
    // MARK: Paged
    func appendRows(_ rows: [Model.Index], newPage: MetaPage, oldPage: MetaPage? = nil, map: ((Model) -> Model)? = nil) {
        let startIndex = newPage.startIndex - 1
        let appendRows = Model.map(rows, startingAt: .init(row: startIndex, section: 0)).map {
            map?($0) ?? $0
        }
        
        if case .reload? = oldPage?.status {
            let upperBound = startIndex+newPage.count
            self.itemsRelay.accept(
                Array(self.itemsRelay.value[0..<startIndex]) +
                appendRows +
                {
                    if self.itemsRelay.value.count > upperBound {
                        return Array(self.itemsRelay.value[upperBound ..< self.itemsRelay.value.count])
                    }
                    
                    return []
                }()
            )
            return
        }
        
        if newPage.currentPage == 0 || newPage.isFirst {
            self.itemsRelay.accept(appendRows)
            self.pageRelay.accept(newPage)
            return
        }

        self.itemsRelay.accept(self.itemsRelay.value + appendRows)
        self.pageRelay.accept(newPage)
    }
    
    func reloadPage(where item: Model) {
        let possiblePage = ((item.indexPath.row / self.pageRelay.value.count) + self.pageRelay.value.firstPage) - 1
        self.refreshPageRelay?.accept(self.pageRelay.value.reload(currentPage: possiblePage))
    }
}
