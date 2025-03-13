//
//  SavedLocationViewModel.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/12/25.
//

import Foundation


enum SavedLocationViewModel: Int, CaseIterable, Identifiable {
    case home
    case work
    
    
    var title: String {
        switch self {
        case .home:
            return "Add Home"
        case .work:
            return "Add Work"
        }
    }
    
    var subtitle: String {
        switch self {
        case .home:
            return "Quick access to your home"
        case .work:
            return "Mark your work location"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .work:
            return "briefcase"
        }
    }
    
    var id: Int {
        self.rawValue
    }
    
}
