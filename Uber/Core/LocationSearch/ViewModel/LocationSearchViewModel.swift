//
//  LocationSearchViewModel.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/23/25.
//

import Foundation
import MapKit


enum LocationSearchViewModel {
    case pickup
    case dropoff
}

enum LocationResultViewConfig {
    case ride(LocationSearchViewModel)
    case savedLocation(SavedLocationViewModel)
}


