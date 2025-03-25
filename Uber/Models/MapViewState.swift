//
//  MapViewState.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/25/25.
//

import Foundation



enum MapViewState {
    case noInput
    case searchingForLocation
    case locationSelected
    case tripRequested
    case tripAccepted
    
    
    var notMainView: Bool {
        return self == .searchingForLocation || self == .locationSelected
    }
    
}
