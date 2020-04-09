//
//  UIFont+Variations.swift
//  SpaAtHome
//
//  Created by Ramon Vicente on 16/08/17.
//  Copyright © 2017 Spa At Home. All rights reserved.
//

import UIKit

public extension UIFont {

    fileprivate func withTraits(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits)) else { return self }
        return UIFont(descriptor: descriptor, size: 0)
    }

    var bold: UIFont {
        return withTraits(.traitBold)
    }

    var italic: UIFont {
        return withTraits(.traitItalic)
    }

    var boldItalic: UIFont {
        return withTraits(.traitBold, .traitItalic)
    }
}
