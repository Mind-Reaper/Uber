//
//  PreviewProvider.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/14/25.
//

import SwiftUI



extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}


class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let mockUser = AppUser.empty()
}
