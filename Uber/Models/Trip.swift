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
    case cancelled
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
    private var _travelDetails: TravelDetails = TravelDetails()
    
    
    init(id: String, riderUid: String, driverUid: String, riderName: String, driverName: String, pickupLocation: UberLocation, dropoffLocation: UberLocation, tripCost: Double, rideType: RideType, state: TripState) {
        self.id = id
        self.riderUid = riderUid
        self.driverUid = driverUid
        self.riderName = riderName
        self.driverName = driverName
        self.pickupLocation = pickupLocation
        self.dropoffLocation = dropoffLocation
        self.tripCost = tripCost
        self.rideType = rideType
        self.state = state
    }
    
    var travelDetails: TravelDetails? {
        return _travelDetails
    }
    
    var distanceToPickup: Double? {
        get {
            _travelDetails.distanceToPickup
        } set {
            _travelDetails.distanceToPickup = newValue
        }
    }
    var distanceToDropoff: Double? {
        get {
            _travelDetails.distanceToDropoff
        } set {
            _travelDetails.distanceToDropoff = newValue
        }
    }
    
    var travelTimeToPickup: Int? {
        get {
            _travelDetails.travelTimeToPickup
        } set {
          
            _travelDetails.travelTimeToPickup = newValue
        }
    }
    var travelTimeToDropoff: Int? {
        get {
            _travelDetails.travelTimeToDropoff
        } set {
            _travelDetails.travelTimeToDropoff = newValue
        }
    }
    
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
        case _travelDetails = "travel_details"
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

struct TravelDetails: Codable {
    var distanceToPickup: Double?
    var distanceToDropoff: Double?
    var travelTimeToPickup: Int?
    var travelTimeToDropoff: Int?
    
    enum CodingKeys: String, CodingKey {
        case distanceToPickup = "distance_to_pickup"
        case distanceToDropoff = "distance_to_dropoff"
        case travelTimeToPickup = "travel_time_to_pickup"
        case travelTimeToDropoff = "travel_time_to_dropoff"
    }
}




struct UpdateTrip: Encodable {
    var state: TripState?
    var travelDetails: TravelDetails?
    
    enum CodingKeys: String, CodingKey {
        case state
        case travelDetails = "travel_details"
    }
    
}
