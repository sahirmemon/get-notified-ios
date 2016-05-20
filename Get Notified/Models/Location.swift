//
//  Location.swift
//  Get Notified
//
//  Created by Sahir Memon on 5/19/16.
//  Copyright © 2016 Sahir Memon. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

let latitudeKey = "latitude"
let longitudeKey = "longitude"
let radiusKey = "radius"
let identifierKey = "identifier"


class Location: NSObject, NSCoding, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var radius : CLLocationDistance
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.radius = 10;
        self.identifier = "GetNotificationLocation"
    }
    
    // MARK:
    // MARK: Code and Decode the class for storing into NSUserDefaults
    
    required init?(coder decoder: NSCoder) {
        let latitude = decoder.decodeDoubleForKey(latitudeKey)
        let longitude = decoder.decodeDoubleForKey(longitudeKey)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        radius = decoder.decodeDoubleForKey(radiusKey)
        identifier = decoder.decodeObjectForKey(identifierKey) as! String
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeDouble(coordinate.latitude, forKey: latitudeKey)
        coder.encodeDouble(coordinate.longitude, forKey: longitudeKey)
        coder.encodeDouble(radius, forKey: radiusKey)
        coder.encodeObject(identifier, forKey: identifierKey)
        
    }
}