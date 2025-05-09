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
    func createTripRequest(tripRequest: TripRequest, completion: @escaping (String?) -> Void) {
        Task {
            do {
                
                try await SupabaseManager
                    .table(tripRequestsTable)
                    .insert(tripRequest)
                    .execute()
                
                debugPrint("Trip request created successfully")
                await MainActor.run {
                     completion(tripRequest.id)
                }
                
                
            } catch {
                debugPrint("Error creating trip \(error.localizedDescription)")
                await MainActor.run {
                     completion(nil)
                }
            }
        }
    }
    
    func updateTripRequest(id: String, update: UpdateTripRequest, completion: @escaping (Bool) -> Void) {
        Task {
            do {
                
                try await SupabaseManager
                    .table(tripRequestsTable)
                    .update(update)
                    .eq("id", value: id)
                    .execute()
                
                debugPrint("Trip request updated successfully")
                await MainActor.run {
                     completion(true)
                }
                
                
            } catch {
                debugPrint("Error updating trip request \(error.localizedDescription)")
                await MainActor.run {
                     completion(false)
                }
            }
        }
    }
    
    func fetchTrips(for user: AppUser, completion: @escaping ([Trip]) -> Void) {
        Task {
            do {
                let trips: [Trip] = try await SupabaseManager
                    .table(tripsTable)
                    .select()
                    .or("rider_uid.eq.\(user.uid),driver_uid.eq.\(user.uid)")
                    .in("state", values: [TripState.completed.rawValue, TripState.cancelled.rawValue])
                    .execute()
                    .value
    
                debugPrint("Fetched \(trips.count) trips for user")
                await MainActor.run {
                     completion(trips)
                }
            } catch {
                debugPrint("Error fetching trips for user \(error.localizedDescription)")
                await MainActor.run {
                     completion([])
                }
            }
        }
    }

    
    
    func fetchTripRequests(forDriver driverUid: String, completion: @escaping ([TripRequest]) -> Void) {
            Task {
                do {
                    let tripRequests: [TripRequest] = try await SupabaseManager
                        .table(tripRequestsTable)
                        .select()
                        .eq("state", value: TripRequestState.requested.rawValue)
                        .not("seen_by", operator: .cs, value: [driverUid])
                        .execute()
                        .value
    
                    debugPrint("Fetched \(tripRequests.count) trip requests for driver")
                    await MainActor.run {
                         completion(tripRequests)
                    }
                } catch {
                    debugPrint("Error fetching trip requests for driver \(error.localizedDescription)")
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
                    .table(tripsTable)
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
    
    func addTripObserver(for user: AppUser) -> AnyPublisher<Trip,  Error> {
        let subject = PassthroughSubject<Trip, Error>()
        let channel = SupabaseManager.channel(tripsChannel)
        
        let tripPostgres = SupabaseManager
            .table(tripsTable)
            .select()
            .or("rider_uid.eq.\(user.uid),driver_uid.eq.\(user.uid)")
            .in("state", values: [TripState.accepted.rawValue, TripState.ongoing.rawValue])
            .limit(1)
            
        let changes =  user.accountType == .rider ? channel.postgresChange(
            AnyAction.self,
            schema: "public",
            table: tripsTable,
            filter: .eq("rider_uid", value: user.uid)
        ) :
        channel.postgresChange(
            AnyAction.self,
            schema: "public",
            table: tripsTable,
            filter: .eq("driver_uid", value: user.uid))
        
        Task {
            do {
                
                let trips: [Trip] = try await tripPostgres.execute().value
                
                if let currentTrip = trips.first {
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
                debugPrint("Error adding trip observer for user \(error.localizedDescription)")
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
    
    func addTripRequestObserver(forRider riderUid: String) -> AnyPublisher<TripRequest, any Error> {
        let subject = PassthroughSubject<TripRequest, Error>()
        let channel = SupabaseManager.channel(tripRequestsChannel)
        
        let tripPostgres = SupabaseManager
            .table(tripRequestsTable)
            .select()
            .eq("rider_uid", value: riderUid)
            .in("state", values: [TripRequestState.requested.rawValue])
            .limit(1)
            
        let changes =  channel.postgresChange(
            AnyAction.self,
            schema: "public",
            table: tripRequestsTable,
            filter: .eq("rider_uid", value: riderUid)
        )
        
        Task {
            do {
                
                let tripRequests: [TripRequest] = try await tripPostgres.execute().value
                
                if let currentTripRequest = tripRequests.first {
                    subject.send(currentTripRequest)
                }
                
                
                await channel.subscribe()
                
                 for try await change in changes {
                     switch change {
                     case .insert(let action):
                         let tripRequest: TripRequest = try action.decodeRecord(as: TripRequest.self, decoder: JSONDecoder())
                         subject.send(tripRequest)
                     case .update(let action):
                         let tripRequest: TripRequest = try action.decodeRecord(as: TripRequest.self, decoder: JSONDecoder())
                         subject.send(tripRequest)
                     case .delete(let action):
                         debugPrint("Deleted \(action.oldRecord)")
                     }
                }
                
            } catch {
                debugPrint("Error adding trip request observer for rider \(error.localizedDescription)")
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
    
    func addTripRequestObserver(forDriver driverUid: String) -> AnyPublisher<TripRequest, any Error> {
        let subject = PassthroughSubject<TripRequest, Error>()
        let channel = SupabaseManager.channel(tripRequestsChannel)
        
      
            
        let changes =  channel.postgresChange(
            AnyAction.self,
            schema: "public",
            table: tripRequestsTable
        )
        
        Task {
            do {
               
                await channel.subscribe()
                
                 for try await change in changes {
                     switch change {
                     case .insert(let action):
                         let tripRequest: TripRequest = try action.decodeRecord(as: TripRequest.self, decoder: JSONDecoder())
                         subject.send(tripRequest)
                     case .update(let action):
                         let tripRequest: TripRequest = try action.decodeRecord(as: TripRequest.self, decoder: JSONDecoder())
                         subject.send(tripRequest)
                     case .delete(let action):
                         debugPrint("Deleted \(action.oldRecord)")
                     }
                }
                
            } catch {
                debugPrint("Error adding trip  request observer for driver \(error.localizedDescription)")
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
