//
//  Bool.swift
//  Uber
//
//  Created by Daniel Onadipe on 4/4/25.
//

import SwiftUI



extension Bool {
    var asBinding: Binding<Bool> {
        Binding<Bool>(
            get: {
                self
            },
            set: {_,__ in
            
            }
        )
    }
}
