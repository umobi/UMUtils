//
//  UIViewController+Preparation.swift
//  SpaAtHome
//
//  Created by Ramon Vicente on 13/07/17.
//  Copyright © 2017 Spa At Home. All rights reserved.
//

import UIKit

extension UIViewController {
    @nonobjc
    public static var defaultNib: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }

    @nonobjc
    public static var storyboardIdentifier: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
}
