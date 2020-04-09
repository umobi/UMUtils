//
//  AlertButton.swift
//  mercadoon
//
//  Created by brennobemoura on 26/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit

public class AlertButton: UIButton {
    private var action: Action? = nil
    
    func addAction(_ action: Action) {
        self.action = action
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.performAction))
        self.addGestureRecognizer(tapGesture)
    }

    @objc func performAction() {
        guard let action = self.action else {
            return
        }

        action.handler?(action)
    }
}
