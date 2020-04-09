//
//  AlertButtonAction.swift
//  mercadoon
//
//  Created by brennobemoura on 26/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit

extension AlertButton {
    open class Action {
        let title: String?
        let handler: ((Action) -> Void)?
        public let style: UIAlertAction.Style

        required public init(title: String?, handler: ((Action) -> Void)? = nil, style: UIAlertAction.Style? = nil) {
            self.title = title
            self.handler = handler
            self.style = style ?? .default
        }

        open func asView() -> UIView {
            let button = AlertButton(frame: .zero)

            button.setTitle(self.title, for: .normal)

            switch self.style {
            case .cancel:
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .black
                button.layer.borderColor = UIColor.black.cgColor
            default:
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .white
                button.layer.borderColor = UIColor.black.cgColor
            }

            button.setTitleColor(button.titleColor(for: .normal)?.withAlphaComponent(0.5), for: .highlighted)
            button.layer.borderWidth = 1
            button.addAction(self)
            
            return button
        }
    }
}
