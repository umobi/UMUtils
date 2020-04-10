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

import Moya
import RxSwift
import RxCocoa

public extension ObservableType where Element == Moya.Response {
    
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
