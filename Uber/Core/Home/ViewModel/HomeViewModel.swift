//
//  HomeViewModel.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/14/25.
//

import SwiftUI
import Combine


class HomeViewModel: ObservableObject {
    
    
    @Published var drivers: [AppUser] = []
    private let userService = SupabaseUserService.shared
    var currentUser: AppUser?
    private var cancellables = Set<AnyCancellable>()
        
    
    
    init () {
        fetchAppUser()
    }
    
    
    func fetchDrivers() {
        userService.fetchDrivers { drivers in
            if let drivers = drivers {
                self.drivers = drivers
            }
        }
    }
    
    func fetchAppUser() {
        
        userService.$user.sink { user in
            self.currentUser = user
            guard user?.accountType == .rider else { return }
            self.fetchDrivers()
        }
        .store(in: &cancellables)
    }
    
}
