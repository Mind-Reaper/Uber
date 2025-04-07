//
//  MapViewState.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/25/25.
//

import Foundation



enum MapViewState: Equatable {
    static func == (lhs: MapViewState, rhs: MapViewState) -> Bool {
        switch (lhs, rhs) {
               case (.noInput, .noInput):
                   return true
               case (.searchingForLocation, .searchingForLocation):
                   return true
               case (.locationSelected, .locationSelected):
                   return true
               case  (.tripRequested(_, _), .tripRequested(_, _)):
                   return true
               case (.tripAccepted(_, _), .tripAccepted(_, _)):
                   return true
               case (.tripCancelled, .tripCancelled):
                   return true
               default:
                   return false
               }
    }
    
    case noInput
    case searchingForLocation
    case locationSelected
    case tripRequested (pickup: UberLocation, dropoff: UberLocation)
    case tripAccepted (pickup:  UberLocation,  dropoff: UberLocation)
    case tripCancelled
    
    
    var notMainView: Bool {
        return self == .searchingForLocation || self == .locationSelected
    }
    
}


extension MapViewState {
    var isNoInput: Bool {
        if case .noInput = self {
            return true
        }
        return false
    }
    
    var isSearchingForLocation: Bool {
        if case .searchingForLocation = self {
            return true
        }
        return false
    }
    
    var isLocationSelected: Bool {
        if case .locationSelected = self {
            return true
        }
        return false
    }
    
    var isTripRequested: Bool {
        if case .tripRequested = self {
            return true
        }
        return false
    }
    
    var isTripAccepted: Bool {
        if case .tripAccepted = self {
            return true
        }
        return false
    }
    
    var isTripCancelled: Bool {
        if case .tripCancelled = self {
            return true
        }
        return false
    }
    
    // If you need to extract associated values
    func getTripRequestLocations() -> (pickup: UberLocation, dropoff: UberLocation)? {
        if case .tripRequested(let pickup, let dropoff) = self {
            return (pickup, dropoff)
        } else if case .tripAccepted(let pickup, let dropoff) = self {
            return (pickup, dropoff)
        }
        return nil
    }
}
