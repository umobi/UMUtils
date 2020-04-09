//
//  String+Utils.swift
//  mercadoon
//
//  Created by brennobemoura on 23/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation

indirect public enum MaskType {
    case raw(String)
    case numeric(String)
    case or(MaskType, MaskType)

    var mask: String? {
        switch self {
        case .raw(let mask):
            return mask
        case .numeric(let mask):
            return mask
        default:
            return nil
        }
    }
}

public extension String {
    private func applyMask(_ mask: String) -> (String, isValid: Bool) {
        var string = self
        mask.enumerated()
            .filter { $0.element != "#" }
            .forEach { mask in
                guard let beforeIndex = string.index(string.endIndex, offsetBy: -1, limitedBy: string.startIndex) else {
                     return
                }

                if let index = string.index(string.startIndex, offsetBy: mask.offset, limitedBy: beforeIndex) {
                    if let char = string.enumerated().first(where: {$0.offset == mask.offset}), char.element == mask.element {
                        return
                    }
                    string.insert(mask.element, at: index)
                }
        }

        return (String(string.prefix(mask.count)), string.count <= mask.count)
    }

    @discardableResult
    func applyMask(_ maskType: MaskType) -> (String, isValid: Bool) {
        switch maskType {
        case .raw(let mask):
            return self.applyMask(mask)
        case .numeric(let mask):
            return self.components(separatedBy: CharacterSet.decimalDigits.inverted)
                .joined()
                .applyMask(mask)
        case .or(let left, let right):
            let leftMasked = self.applyMask(left)
            if !leftMasked.1 {
                return self.applyMask(right)
            }

            return leftMasked
        }
    }

    func mask(_ mask: MaskType) -> String {
        return self.applyMask(mask).0
    }
}
