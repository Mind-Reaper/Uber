//
//  SupabaseTripService.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/18/25.
//

import Foundation


class SupabaseTripService: TripService {
    
    static let shared = SupabaseTripService()
 
    func createTrip(trip: Trip, completion: @escaping (String?) -> Void) {
        Task {
            do {
                
                try await SupabaseManager
                    .table(tableName)
                    .insert(trip)
                    .execute()
                
                debugPrint("Trip created successfully")
                return completion(trip.id)
            } catch {
                debugPrint("Error creating trip: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    
}
