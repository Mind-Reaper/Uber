//
//  SupabaseTripService.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/18/25.
//

import Foundation
import Combine
import Supabase


class SupabaseTripService: TripService {
 
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
    
    
    func updateTrip(id: String, update: UpdateTrip, completion: @escaping (Bool) -> Void) {
        Task {
            do {
                try await SupabaseManager
                    .table(tableName)
                    .update(update)
                    .eq("id", value: id)
                    .execute()
                
                await MainActor.run {
                    completion(true)
                }
                
                
            } catch {
                debugPrint("Error updating trip \(error.localizedDescription)")
                
                await MainActor.run {
                    completion(false)
                }
            }
        }
    }
    
    func addTripObserver(forRider riderUid: String) -> AnyPublisher<Trip,  Error> {
        let subject = PassthroughSubject<Trip, Error>()
        let channel = SupabaseManager.channel(channelName)
        
        let tripPostgres = SupabaseManager
            .table(tableName)
            .select()
            .eq("rider_uid", value: riderUid)
            .in("state", values: [TripState.requested.rawValue, TripState.accepted.rawValue])
            .single()
            
        
        let changes = channel.postgresChange(
            AnyAction.self,
            schema: "public",
            table: tableName,
            filter: .eq("rider_uid", value: riderUid)
        )
        
        Task {
            do {
                
                let currentTrip: Trip? = try await tripPostgres.execute().value
                
                if let currentTrip = currentTrip {
                    subject.send(currentTrip)
                }
                
                
                await channel.subscribe()
                
                 for try await change in changes {
                     switch change {
                     case .insert(let action):
                         let trip: Trip = try action.decodeRecord(as: Trip.self, decoder: JSONDecoder())
                         subject.send(trip)
                     case .update(let action):
                         let trip: Trip = try action.decodeRecord(as: Trip.self, decoder: JSONDecoder())
                         subject.send(trip)
                         
                     case .delete(let action):
                         debugPrint("Deleted \(action.oldRecord)")
                     }
                    
                }
                
            } catch {
                debugPrint("Error adding trip observer for rider \(error.localizedDescription)")
                subject.send(completion: .failure(error))
            }
        }
        
        return subject.handleEvents(
            receiveCancel: {
                Task {
                    await channel.unsubscribe()
                }
            }
        )
        .eraseToAnyPublisher()
        
    }
    
    
  
    
    func addTripObserver(forDriver driverUid: String) -> AnyPublisher<Trip,  Error> {
        let subject = PassthroughSubject<Trip, Error>()
        let channel = SupabaseManager.channel(channelName)
        
        let tripPostgres = SupabaseManager
            .table(tableName)
            .select()
            .eq("driver_uid", value: driverUid)
            .in("state", values: [TripState.requested.rawValue, TripState.accepted.rawValue])
            .single()
            
        
        let changes = channel.postgresChange(
            AnyAction.self,
            schema: "public",
            table: tableName,
            filter: .eq("driver_uid", value: driverUid)
        )
        
        Task {
            do {
                
                let currentTrip: Trip? = try await tripPostgres.execute().value
                
                if let currentTrip = currentTrip {
                    subject.send(currentTrip)
                }
                
                
                await channel.subscribe()
                
                 for try await change in changes {
                     switch change {
                     case .insert(let action):
                         let trip: Trip = try action.decodeRecord(as: Trip.self, decoder: JSONDecoder())
                         subject.send(trip)
                     case .update(let action):
                         let trip: Trip = try action.decodeRecord(as: Trip.self, decoder: JSONDecoder())
                         subject.send(trip)
                         
                     case .delete(let action):
                         debugPrint("Deleted \(action.oldRecord)")
                     }
                    
                }
                
            } catch {
                debugPrint("Error adding trip observer for driver \(error.localizedDescription)")
                subject.send(completion: .failure(error))
            }
        }
        
        return subject.handleEvents(
            receiveCancel: {
                Task {
                    await channel.unsubscribe()
                }
            }
        )
        .eraseToAnyPublisher()
        
    }
 
    
    
    
}
