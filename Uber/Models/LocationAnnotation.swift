//
//  LocationAnnotation.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/29/25.
//

import Foundation
import MapKit


class LocationAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    let viewModel: LocationSearchViewModel
    
    init(coordinate: CLLocationCoordinate2D, viewModel: LocationSearchViewModel) {
        self.coordinate = coordinate
        self.viewModel = viewModel
    }
}
