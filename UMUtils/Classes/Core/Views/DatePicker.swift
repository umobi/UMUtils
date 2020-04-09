//
//  DatePicker.swift
//  SpaAtHome
//
//  Created by Ramon Vicente on 14/08/17.
//  Copyright © 2017 Spa At Home. All rights reserved.
//

import UIKit

open class DatePicker: UIDatePicker {

    public var pickerColor: UIColor?
    public var separatorColor: UIColor?

    override open func layoutSubviews() {
        super.layoutSubviews()

        if let pickerColor = self.pickerColor {
            self.setValue(pickerColor, forKey: "textColor")
            self.setValue(false, forKey: "highlightsToday")
        }
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        if let pickerView = self.subviews.first, let separatorColor = self.separatorColor {

            for subview in pickerView.subviews where subview.frame.height <= 5 {
                subview.backgroundColor = separatorColor
                subview.tintColor = separatorColor
            }
        }
    }
}
