//
//  CLPlacemark.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/20/25.
//

import CoreLocation
import MapKit

extension CLPlacemark {
    
    var formattedAddress: String {
        var addressString = ""
        
        if let thoroughfare = thoroughfare {
            addressString += thoroughfare
        }
        
        if let subThoroughfare = subThoroughfare {
            addressString += " \(subThoroughfare)"
        }
        
        if let subAdministrativeArea = subAdministrativeArea {
            addressString += ", \(subAdministrativeArea)"
        }
        
        return addressString
       
    }
}
    





