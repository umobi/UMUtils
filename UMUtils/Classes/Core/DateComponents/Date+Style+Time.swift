//
//  Date+Style+Time.swift
//  TokBeauty
//
//  Created by brennobemoura on 07/11/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import Foundation

public extension Date.Style {

    struct Time {
        public enum Granularity {
            case hour(Int)
            case minute(Int)
        }

        private let granularity: Granularity

        fileprivate init(_ granularity: Granularity) {
            self.granularity = granularity
        }

        public var regular: String {
            switch self.granularity {
            case .hour(let hour):
                return String(format: "%02d", hour)
            case .minute(let minute):
                return String(format: "%02d", minute)
            }
        }

        public var short: String {
            switch self.granularity {
            case .hour(let hour):
                return "\(hour)"
            case .minute(let minute):
                return "\(minute)"
            }
        }
    }

    var hour: Time {
        return .init(.hour(self.date.components.hour))
    }

    var minute: Time {
        return .init(.minute(self.date.components.minute))
    }

}
