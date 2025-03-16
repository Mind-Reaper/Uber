//
//  SupabaseUserService.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/16/25.
//

import Foundation

class  SupabaseUserService: UserService {
    
    static let shared = SupabaseUserService()
    
    @Published var user: AppUser?
    
    init() {
        fetchUser()
    }
    
    
    func fetchUser() {
        Task {
            guard let uid = SupabaseManager.auth.currentUser?.id.uuidString else { return }
            do {
                let appUser: AppUser = try await SupabaseManager.table(AuthViewModel.usersTable)
                    .select()
                    .eq("uid", value: uid)
                    .single()
                    .execute()
                    .value
                
                await MainActor.run {
                    self.user = appUser
                }
            } catch {
                debugPrint("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchDrivers(completion: @escaping ([AppUser]?) -> Void)  {
        Task {
            do  {
                let drivers: [AppUser] =   try await SupabaseManager
                    .table(AuthViewModel.usersTable)
                    .select()
                    .eq("account_type", value: AccountType.driver.rawValue)
                    .execute()
                    .value
                
                await MainActor.run {
                    completion(drivers)
                }
                
            } catch {
                debugPrint("Error fetching drivers: \(error.localizedDescription)")
                await MainActor.run {
                    completion(nil)
                }
            }
        }
    }
    
}

