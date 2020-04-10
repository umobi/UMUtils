//
//  Date+Style.swift
//  TokBeauty
//
//  Created by brennobemoura on 07/11/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import Foundation

public extension Date {
    struct Style {
        public let date: Date

        fileprivate init(_ date: Date) {
            self.date = date
        }
    }

    var style: Style {
        return .init(self)
    }
}
