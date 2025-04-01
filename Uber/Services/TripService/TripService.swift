//
//  TripService.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/18/25.
//

import Combine
import Foundation


protocol TripService {
    
    func createTripRequest(tripRequest: TripRequest, completion: @escaping (String?) -> Void)
    func updateTripRequest(id: String, update: UpdateTripRequest, completion: @escaping (Bool) -> Void)
    
    func updateTrip(id: String, update: UpdateTrip, completion: @escaping (Bool) -> Void)
    
//    func fetchTrips(forDriver driverUid: String, completion: @escaping ([Trip]) -> Void)
    func fetchTripRequests(forDriver driverUid: String, completion: @escaping ([TripRequest]) -> Void)
    
    func addTripObserver(for user: AppUser) -> AnyPublisher<Trip, Error>
//    func addTripObserver(forDriver driverUid: String) -> AnyPublisher<Trip, Error>
    func addTripRequestObserver(forRider riderUid: String) -> AnyPublisher<TripRequest, Error>
    func addTripRequestObserver(forDriver driver: String) -> AnyPublisher<TripRequest, Error>
    
}

extension TripService {
     var tripsTable: String {
        "trips"
    }
    
    var tripRequestsTable: String {
       "trip-requests"
   }
    
    var tripsChannel: String {
        "trips_channel"
    }
    
    var tripRequestsChannel: String {
        "trip_requests_channel"
    }
}
