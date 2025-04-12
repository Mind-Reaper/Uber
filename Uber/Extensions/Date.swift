//
//  Date.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/3/25.
//

import Foundation


extension Date {
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: self)
    }
    
}
