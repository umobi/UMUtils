//
//  Dropable.swift
//  SPA at home
//
//  Created by Ramon Vicente on 25/04/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import Foundation

public protocol Dropable {
    var dropableId: String { get }
    var title: String { get }
}

extension Equatable where Self : Dropable {
}

public func == (lhs: Dropable?, rhs: Dropable?) -> Bool {
    return lhs?.dropableId == rhs?.dropableId
}

public func != (lhs: Dropable?, rhs: Dropable?) -> Bool {
    return lhs?.dropableId != rhs?.dropableId
}
