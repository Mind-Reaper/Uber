//
//  SavedLocation.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/13/25.
//

import CoreLocation

struct SavedLocation: Codable {
    let title: String
    let address: String
    let latitude: Double
    let longitude: Double
    
    static func fromUberLocation(_ location: UberLocation) -> SavedLocation {
        return SavedLocation(
            title: location.title,
            address: location.address,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
    }
    
    func toUberLocation() -> UberLocation {
        return UberLocation(
            title:title,
            address: address,
            coordinate: UserCoordinates(
                latitude: latitude,
                longitude: longitude
            )
        )
    }
    
}
