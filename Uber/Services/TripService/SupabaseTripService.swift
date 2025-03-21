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
                await MainActor.run {
                     completion(trip.id)
                }
                
                
            } catch {
                debugPrint("Error creating trip \(error.localizedDescription)")
                await MainActor.run {
                     completion(nil)
                }
            }
        }
    }
    
    func fetchTrips(forDriver driverUid: String, completion: @escaping ([Trip]) -> Void) {
        
        Task {
            do {
                let trips: [Trip] = try await SupabaseManager
                    .table(tableName)
                    .select()
                    .eq("driver_uid", value: driverUid)
                    .execute()
                    .value
    
                debugPrint("Fetched \(trips.count) trips for driver")
                await MainActor.run {
                     completion(trips)
                }
            } catch {
                debugPrint("Error fetching trips for driver \(error.localizedDescription)")
                await MainActor.run {
                     completion([])
                }
            }
        }
        
    }
    
    
    
}
