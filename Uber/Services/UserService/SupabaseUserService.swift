//
//  SupabaseUserService.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/16/25.
//

import Foundation
import Combine

class  SupabaseUserService: UserService {
    
    
    @Published var user: AppUser?
    var userPublisher: AnyPublisher<AppUser?, Never> {
            $user.eraseToAnyPublisher()
        }
    
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
    
    func updateUser(uid: String, updateUser: UpdateUser, completion: @escaping (AppUser?) -> Void) {
        Task {
            do {
                let appUser: AppUser = try await SupabaseManager.table("users")
                .update(updateUser)
                .eq("uid", value: uid)
                .single()
                .execute().value
                
                debugPrint("Updated user with uid \(uid)")
                await MainActor.run {
                    self.user = appUser
                    completion(appUser)
                }

            } catch {
                debugPrint("Error updating user \(error.localizedDescription)")
                await MainActor.run {
                    completion(nil)
                }
            }
        }
    }
    
}

