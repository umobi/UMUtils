//
//  String+Boldify.swift
//  Umobi
//
//  Created by Ramon Vicente on 18/07/17.
//  Copyright © 2017 Umobi. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    func boldify(with string: String) -> NSAttributedString {
        return self.setAttributes([.font: UIFont(name: "HelveticaNeue-Bold", size: 15)!], string: string)
    }

    func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, string: String) -> NSAttributedString {
        let nsString = self.string as NSString
        let attributedString = NSMutableAttributedString(attributedString: self)

        let range = nsString.range(of: string)

        if range.location != NSNotFound {
            attributedString.setAttributes(attrs, range: range)
        }

        return attributedString
    }
}

public extension NSString {
    func boldify(with string: String) -> NSAttributedString {
        let attributedString = NSAttributedString(string: self as String)
        return attributedString.boldify(with:string)
    }

    func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, string: String) -> NSAttributedString {
        return NSAttributedString(string: self as String).setAttributes(attrs, string: string)
    }
}

public extension String {
    func boldify(with string: String) -> NSAttributedString {
        return (self as NSString).boldify(with:string)
    }

    func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, string: String) -> NSAttributedString {
        return (self as NSString).setAttributes(attrs, string: string)
    }
}
