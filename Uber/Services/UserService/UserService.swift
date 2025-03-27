//
//  UserService.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/16/25.
//

import Foundation
import Combine


protocol UserService {
    
    var user: AppUser? { get }
    var userPublisher: AnyPublisher<AppUser?, Never> { get }
    
    func fetchUser()
    func fetchDrivers(completion: @escaping ([AppUser]?) -> Void)
    
}
