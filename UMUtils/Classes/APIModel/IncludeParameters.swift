//
//  IncludeParameters.swift
//  mercadoon
//
//  Created by brennobemoura on 28/08/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation

public protocol IncludeParameter: RawRepresentable where RawValue == String {
    static func parameter(_ include: Self...) -> String
}

public protocol IncludeParameters {
    associatedtype Include: IncludeParameter
}

public extension IncludeParameter {
    static func parameter(_ include: Self...) -> String {
        return include[0..<include.count-1].reduce("") {
            return "\($0)\($1.rawValue),"
            } + include[include.count - 1].rawValue
    }
}
