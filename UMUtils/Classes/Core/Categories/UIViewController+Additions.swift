//
//  UIViewController+Additions.swift
//  Umobi
//
//  Created by Ramon Vicente on 25/03/17.
//  Copyright © 2017 Umobi. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    var isRootViewController: Bool {
        guard navigationController?.viewControllers[0] != self else {
            return true
        }
        
        return false
    }

    var isModal: Bool {
        guard self.presentingViewController == nil else {
            return true
        }

        guard self.navigationController?.presentedViewController != self.navigationController else {
            return true
        }

        guard self.tabBarController?.presentingViewController is UITabBarController else {
            return false
        }

        return true
    }
}
