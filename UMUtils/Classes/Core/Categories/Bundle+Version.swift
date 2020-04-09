//
//  Bundle+Version.swift
//  SpaAtHome
//
//  Created by Ramon Vicente on 07/08/17.
//  Copyright © 2017 Spa At Home. All rights reserved.
//

import Foundation

public extension Bundle {
    var releaseVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersion: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
