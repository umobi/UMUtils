//
//  Moya+ObjectMapper.swift
//  TokBeauty
//
//  Created by Ramon Vicente on 17/03/17.
//  Copyright © 2017 TokBeauty. All rights reserved.
//

import Foundation
import Moya

public extension Response {

    func mapApi<T: Decodable>(_ type: T.Type) -> APIResult<T> {
        if self.statusCode == 204 {
            return APIResult.empty
        }

        do {
            return .success(try JSONDecoder().decode(T.self, from: self.data))
        } catch {
            APIErrorManager.shared?.didReviceError(error)
            return APIResult.error(error)
        }
    }
}
