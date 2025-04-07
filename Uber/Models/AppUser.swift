//
//  AppUser.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/5/25.
//

import Foundation

enum AccountType: String, Codable {
    case rider
    case driver
}


struct AppUser: Identifiable, Codable {
    let uid: String
    let email: String
    let firstname: String
    let lastname: String
    var accountType: AccountType
    var coordinates: UserCoordinates
    var home: SavedLocation?
    var work: SavedLocation?
    
    enum CodingKeys: String, CodingKey {
        case uid
        case email
        case firstname
        case lastname
        case accountType = "account_type"
        case coordinates
        case home
        case work
    }
    
    
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
            lastname: "Doe",
            accountType: .rider,
            coordinates: UserCoordinates(latitude: 37.38, longitude: -122.05)
        )
    }
}

struct UpdateUser: Encodable {
    var firstname: String?
    var lastname: String?
    var accountType: AccountType?
    var home: SavedLocation?
    var work: SavedLocation?
    var coordinates: UserCoordinates?
    
    enum CodingKeys: String, CodingKey {
        case firstname
        case lastname
        case accountType = "account_type"
        case home
        case work
        case coordinates
    }
}
