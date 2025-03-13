//
//  AuthViewModel.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/5/25.
//

import Foundation
import Supabase


enum AuthViewType {
    case login
    case signup
}



class AuthViewModel: ObservableObject {
    @Published var userSession: User?
    @Published var currentUser: AppUser?
    
    
    static let usersTable: String = "users"
    
    
    init() {
        userSession = SupabaseManager.auth.currentUser
        fetchAppUser()
        debugPrint("User Session: \(String(describing: userSession))")
    }
    
    func signIn(usingEmail email: String, password: String) {
        Task {
            do {
                let result = try await SupabaseManager.auth.signIn(email: email, password: password)
                
                await MainActor.run {
                    self.userSession = result.user
                }
                
            } catch {
                debugPrint("Failed to sign in with error: \(error.localizedDescription)")
            }
        }
    }
    
    func signUp(usingEmail email: String, password: String, firstname: String, lastname: String)  {
        Task {
            do {
                let result = try await SupabaseManager.auth.signUp(email: email, password: password)
                
                let user = result.user
                
                await MainActor.run {
                    self.userSession = user
                }
                
                let appUser = AppUser(uid: user.id.uuidString, email: email, firstname: firstname, lastname: lastname)
                
                try await SupabaseManager.table(AuthViewModel.usersTable)
                    .insert(appUser)
                    .execute()
                
                
            } catch {
                debugPrint("Failed to sign up with error: \(error.localizedDescription)")
                
            }
        }
    }
    
    
    func signout() {
        Task {
            do {
                try await SupabaseManager.auth.signOut()
                await MainActor.run {
                    self.userSession = nil
                }
                
            } catch {
                debugPrint("Error signing out: \(error.localizedDescription)")
            }
        }
    }
    
    
    func fetchAppUser() {
        Task {
            guard let uid = self.userSession?.id.uuidString else { return }
            
            do {
                let response = try await SupabaseManager.table(AuthViewModel.usersTable)
                    .select()
                    .eq("uid", value: uid)
                    .single()
                    .execute()
                
                let userData = response.data
                let decoder = JSONDecoder()
                let appUser = try decoder.decode(AppUser.self, from: userData)
                
                debugPrint("Appuser: \(appUser)")
                
                await MainActor.run {
                    self.currentUser = appUser
                }
                
                } catch {
                    debugPrint("Error fetching user data: \(error.localizedDescription)")
                }
                
            }
        }
 }

