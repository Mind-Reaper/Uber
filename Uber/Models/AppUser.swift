//
//  AppUser.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/5/25.
//

import Foundation


struct AppUser: Identifiable, Codable {
    let uid: String
    let email: String
    let firstname: String
    let lastname: String
    var home: SavedLocation?
    var work: SavedLocation?
    
    
    var id : String {
        uid
    }
    
    var fullname: String {
        "\(firstname) \(lastname)"
    }
    
    
    static func empty() -> AppUser {
        .init(
            uid: "",
            email: "johndoe@domain.com",
            firstname: "John",
            lastname: "Doe"
        )
    }
}

struct UpdateUser: Encodable {
    var firstname: String?
    var lastname: String?
    var home: SavedLocation?
    var work: SavedLocation?
}
