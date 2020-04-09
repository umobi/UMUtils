//
//  AIFlatSwitch+Rx.swift
//  Pods
//
//  Created by Ramon Vicente on 22/03/17.
//
//

import UIKit
import RxCocoa
import RxSwift
import AIFlatSwitch

extension Reactive where Base: AIFlatSwitch {
    
    public var isSelected: ControlProperty<Bool> {
        return value
    }
    
    public var value: ControlProperty<Bool> {
        return UIControl.valuePublic(
            self.base,
            getter: { uiSwitch in
                uiSwitch.isSelected
        }, setter: { uiSwitch, value in
            uiSwitch.isSelected = value
        }
        )
    }
    
}
