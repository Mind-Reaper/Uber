//
//  DriverAnnotation.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/16/25.
//

import MapKit


class DriverAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    let uid: String
    
    init(driver: AppUser) {
        self.uid = driver.uid
        self.coordinate = driver.coordinates.toCLLocationCoordinate2D()
    }
    
}
