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
