//
//  TripService.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/18/25.
//

import Foundation


protocol TripService {
    
    func createTrip(trip: Trip, completion: @escaping (String?) -> Void)
    
}

extension TripService {
     var tableName: String {
        "trips"
    }
}
