//
//  CLLocationCoordinate2D+Dictionary.swift
//  SpaAtHome
//
//  Created by Ramon Vicente on 22/08/17.
//  Copyright © 2017 Spa At Home. All rights reserved.
//

import Foundation
import CoreLocation

public typealias CLLocationCoordinateDictionary = [String: CLLocationDegrees]

public extension CLLocationCoordinate2D {

    private static let lat = "lat"
    private static let lon = "lon"

    var asDictionary: CLLocationCoordinateDictionary {
        return [CLLocationCoordinate2D.lat: self.latitude,
                CLLocationCoordinate2D.lon: self.longitude]
    }

    var asData: Data {
        return NSKeyedArchiver.archivedData(withRootObject: self.asDictionary)
    }

    init(dict: CLLocationCoordinateDictionary) {
        self.init(latitude: dict[CLLocationCoordinate2D.lat]!,
                  longitude: dict[CLLocationCoordinate2D.lon]!)
    }

    init?(data: Data) {
        if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? CLLocationCoordinateDictionary {
            self.init(latitude: dict[CLLocationCoordinate2D.lat]!,
                      longitude: dict[CLLocationCoordinate2D.lon]!)
        } else {
            return nil
        }
    }
    
}
