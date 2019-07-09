//
//  PinExtension.swift
//  VirtualTourist
//
//  Created by Haya Mousa on 06/07/2019.
//  Copyright © 2019 HayaMousa. All rights reserved.
//

import Foundation
import MapKit

extension Pin {
    var coordinate: CLLocationCoordinate2D {
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    func compare(to coordinate: CLLocationCoordinate2D) -> Bool {
        return (latitude == coordinate.latitude && longitude == coordinate.longitude)
    }
}
