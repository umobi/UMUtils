//
//  UIViewController+Storyboard.swift
//  Umobi
//
//  Created by Ramon Vicente on 10/1/16.
//  Copyright © 2017 Umobi. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    class func fromStoryboard(_ identifier: String? = nil, _ storyboard: String? = nil) -> Self {
        let identifier = identifier != nil ? identifier!: "\(self)Identifier"
        let storyboard = storyboard != nil ? storyboard!: "Main"
        return fromStoryboard(identifier: identifier, storyboard: storyboard)
    }
    
    class func fromStoryboard<T>(identifier: String, storyboard: String) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        return (storyboard.instantiateViewController(withIdentifier: identifier) as? T)!
    }
}
