//
//  Trip.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/17/25.
//

import Foundation


enum TripState: String, Codable {
    case requested
    case rejected
    case accepted
}


struct Trip: Identifiable, Codable {
    let id: String
    let riderUid: String
    let driverUid: String
    let riderName: String
    let driverName: String
    let pickupLocation: UberLocation
    let dropoffLocation: UberLocation
    let tripCost: Double
    let rideType: RideType
    let state: TripState
    
    var distanceToPickup: Double?
    var distanceToDropoff: Double?
    
    var travelTimeToPickup: Int?
    var travelTimeToDropoff: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case riderUid = "rider_uid"
        case driverUid = "driver_uid"
        case riderName = "rider_name"
        case driverName = "driver_name"
        case pickupLocation = "pickup_location"
        case dropoffLocation = "dropoff_location"
        case tripCost = "trip_cost"
        case rideType = "ride_type"
        case state
    }
    
    
    
    static func empty() -> Trip {
        return Trip(
            id: "",
            riderUid: "",
            driverUid: "",
            riderName: "Daniel",
            driverName: "David",
            pickupLocation: UberLocation(
                title: "Philz Coffee", address: "123 Main St", coordinate: UserCoordinates(
                    latitude: 36.4954, longitude: 121.7449
                )
            ),
            dropoffLocation: UberLocation(
                title: "Coffee Lovers", address: "1696 Tully Rd, San Jose, CA 95125", coordinate: UserCoordinates(
                    latitude: 22.3964, longitude: 114.1095
                )
            ),
            tripCost: 53.0,
            rideType: .uberX,
            state: .requested
        )
    }
    
}




struct UpdateTrip: Encodable {
    var state: TripState?
}
