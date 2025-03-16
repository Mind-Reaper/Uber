//
//  UserService.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/16/25.
//

import Foundation


protocol UserService {
    
    func fetchUser()
    
    func fetchDrivers(completion: @escaping ([AppUser]?) -> Void)
    
}
