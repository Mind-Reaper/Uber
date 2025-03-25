//
//  TripService.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/18/25.
//

import Combine
import Foundation


protocol TripService {
    
    func createTrip(trip: Trip, completion: @escaping (String?) -> Void)
    func fetchTrips(forDriver driverUid: String, completion: @escaping ([Trip]) -> Void)
    func updateTripState(id: String, state: TripState, completion: @escaping (Bool) -> Void)
    func addTripObserver(forRider riderUid: String) -> AnyPublisher<Trip, Error>
    
}

extension TripService {
     var tableName: String {
        "trips"
    }
    
    var channelName: String {
        "trips_channel"
    }
}
