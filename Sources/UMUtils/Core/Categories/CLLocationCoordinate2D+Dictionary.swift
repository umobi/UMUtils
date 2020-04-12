//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
