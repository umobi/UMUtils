//
//  UIColor+Image.swift
//  Umobi
//
//  Created by Ramon Vicente on 30/06/17.
//  Copyright © 2017 Umobi. All rights reserved.
//

import UIKit

public extension UIColor {
    var image: UIImage? {
        return UIImage(color: self)
    }
}
