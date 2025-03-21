//
//  Double.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/3/25.
//

import Foundation


extension Double {
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "NGN"
        return formatter
    }
    
    private var distanceFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }
    
    
    func toCurrency() -> String {
        return currencyFormatter.string(for: self) ?? ""
    }
    
    func distanceInMilesString() -> String {
        return distanceFormatter.string(for: self / 1609.34) ?? ""
    }
}
