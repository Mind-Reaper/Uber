//
//  RideType.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/26/25.
//

import Foundation


enum RideType: String, CaseIterable, Identifiable, Codable {
    case uberX
    case black
    case uberXL
    
    
    var id: String {
        return rawValue
    }
    
    var description: String {
        switch self {
        case .uberX: return "UberX"
        case .black: return "UberBlack"
        case .uberXL: return "UberXL"
        }
    }
    
    
    var image: String {
        switch self {
        case .uberX: return "uber-x"
        case .black: return "uber-black"
        case .uberXL: return "uber-x"
        }
    }
    
    
    var baseFare: Double {
        switch self {
        case .uberX: return 1200
        case .black: return 3000
        case .uberXL: return 2000
        }
    }
    
    func computePrice(for distanceInMeters: Double) -> Double {
        let distanceInMiles = distanceInMeters / 1609.34
        return switch self {
        case .uberX: distanceInMiles * 250 + baseFare
        case .black:
            distanceInMiles * 500 + baseFare
        case .uberXL:
            distanceInMiles * 350 + baseFare
        }
    }
}
