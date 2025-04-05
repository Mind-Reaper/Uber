//
//  TripRequest.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/31/25.
//

import Foundation


enum TripRequestState: String, Codable {
    case requested
    case cancelled
    case accepted
}

struct TripRequest: Identifiable, Codable, Equatable {
    static func == (lhs: TripRequest, rhs: TripRequest) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let riderUid: String
    let driverUid: String?
    let riderName: String
    let driverName: String?
    let pickupLocation: UberLocation
    let dropoffLocation: UberLocation
    let tripCost: Double
    let rideType: RideType
    let state: TripRequestState
    let seenBy: [String]
    
    
    
    
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
        case seenBy = "seen_by"
    }
    
    
    static func empty() -> TripRequest {
        return TripRequest(
            id: "",
            riderUid: "",
            driverUid: nil,
            riderName: "Daniel",
            driverName: nil,
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
            state: .requested,
            seenBy:  []
        )
    }
}
    


struct UpdateTripRequest: Encodable {
    var driverUid: String?
    var driverName: String?
    var seenBy: [String]?
    var state: TripRequestState?
    
    enum CodingKeys: String, CodingKey {
        case driverUid = "driver_uid"
        case driverName = "driver_name"
        case seenBy = "seen_by"
        case state
    }
}
