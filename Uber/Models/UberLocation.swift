//
//  UberLocation.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/3/25.
//

import CoreLocation



struct UberLocation: Codable {
    let title: String
    let address: String
    let coordinate: UserCoordinates
    
    
    
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        
        return CLLocationCoordinate2D(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
            )
    }
    
}
