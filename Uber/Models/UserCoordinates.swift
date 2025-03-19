//
//  UserCoordinates.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/14/25.
//

import CoreLocation



struct UserCoordinates: Codable {
    let latitude: Double
    let longitude: Double
    
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func from(coordinate: CLLocationCoordinate2D) -> UserCoordinates {
        return UserCoordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
}
