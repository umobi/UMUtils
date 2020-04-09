//
//  CNPPopupTheme+Material.swift
//  Pods
//
//  Created by Ramon Vicente on 21/03/17.
//
//

import Foundation
import CNPPopupController

public extension CNPPopupTheme {
    
    class var material: CNPPopupTheme {
        
        let theme = CNPPopupTheme()
		theme.backgroundColor = UIColor.white;
		theme.cornerRadius = 2.0;
		theme.popupContentInsets = .zero;
		theme.popupStyle = .centered;
		theme.presentationStyle = .slideInFromBottom;
		theme.dismissesOppositeDirection = false;
		theme.maskType = .dimmed;
		theme.shouldDismissOnBackgroundTouch = true;
		theme.movesAboveKeyboard = true;
		theme.contentVerticalPadding = 0.0;
		theme.maxPopupWidth = 280.0;
        theme.animationDuration = 0.3
        
        return theme;
    }
	
}
