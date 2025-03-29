//
//  Logger.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/5/25.
//

import Foundation



func debugPrint( _ items: Any...,
                 separator: String = " ",
                 terminator: String = "\n") {
    let itemsAsString: [String] = items.map { item in
        return String(describing: item)
    }
    print("DEBUG: \(itemsAsString.joined(separator: separator))\n", terminator: terminator)
}
