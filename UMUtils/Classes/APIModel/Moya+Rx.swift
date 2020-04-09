//
//  Moya+Observable.swift
//  TokBeauty
//
//  Created by Ramon Vicente on 14/03/17.
//  Copyright © 2017 TokBeauty. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa

public extension ObservableType where E == Moya.Response {
    
    func map<T: Decodable>(_ mappableType: T.Type) -> Observable<APIResult<T>> {
        return flatMap { response -> Observable<APIResult<T>> in
            return .just(response.mapApi(mappableType))
        }.do(onError: { error in
            APIErrorManager.shared?.didReviceError(error)
            print("[Decoding \(T.self)] error \(error)")
        })
    }
    
    // MARK: Map to Driver
    
    func mapDriver<T: Decodable>(_ mappableType: T.Type) -> Driver<APIResult<T>> {
        return map(mappableType).asDriver(onErrorRecover: { (error) -> Driver<APIResult<T>> in
            return .just(.error(error))
        })
    }
}
