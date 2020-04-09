//
//  String+Validations.swift
//  Umobi
//
//  Created by Ramon Vicente on 19/03/17.
//  Copyright © 2017 Umobi. All rights reserved.
//

import Foundation

public extension String {
    
    var isValidEmail: Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return self.isValid(pattern: pattern)
    }

    var isValidPhone: Bool {
        let pattern = "^(?:(?:\\+|00)?(55)\\s?)?(?:\\(?([1-9][0-9])\\)?\\s?)?(?:((?:9\\d|[2-9])\\d{3})\\-?(\\d{4,5}))$"
        return self.isValid(pattern: pattern) 
    }

    func isValid(pattern: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
}
