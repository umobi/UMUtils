//
//  UIWindow+ViewControllers.swift
//  SPA at home
//
//  Created by Ramon Vicente on 26/04/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import UIKit
import Material

public extension TransitionController {
    @objc var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
}
