//
//  Array.swift
//  Uber
//
//  Created by Daniel Onadipe on 4/1/25.
//

import Foundation


extension Array where Element: Equatable {
    
    func appendIfNotContains(_ element: Element) -> [Element] {
        if !self.contains(element) {
                    var newArray = self
                    newArray.append(element)
                    return newArray
                }
                return self
    }
}
