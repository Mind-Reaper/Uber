//
//  Trip.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/17/25.
//

import Foundation


struct Trip: Identifiable, Codable {
    let id: String
    let riderUid: String
    let driverUid: String
    let riderName: String
    let driverName: String
    let riderLocation: UberLocation
    let driverLocation: UberLocation
    let tripCost: Double
    let rideType: RideType
    
    enum CodingKeys: String, CodingKey {
        case id
        case riderUid = "rider_uid"
        case driverUid = "driver_uid"
        case riderName = "rider_name"
        case driverName = "driver_name"
        case riderLocation = "rider_location"
        case driverLocation = "driver_location"
        case tripCost = "trip_cost"
        case rideType = "ride_type"
    }
    
}
