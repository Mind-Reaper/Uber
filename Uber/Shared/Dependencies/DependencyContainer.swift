//
//  DependencyContainer.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/27/25.
//

import Foundation


class DependencyContainer {
    
    
    static let shared = DependencyContainer()
    
    lazy var userService: UserService = {
        SupabaseUserService()
    }()
    
    lazy var tripService: TripService = {
        SupabaseTripService()
    }()
    
    func makeAuthViewModel() -> AuthViewModel {
        AuthViewModel(userService: userService)
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(userService: userService, tripService: tripService)
    }
    
    private init() {}
    
}
