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
    
    
    func toCurrency() -> String {
        return currencyFormatter.string(for: self) ?? ""
    }
}
