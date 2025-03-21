//
//  AuthViewModel.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/5/25.
//

import Foundation
import Supabase
import Combine


enum AuthViewType {
    case login
    case signup
}



class AuthViewModel: ObservableObject {
    @Published var userSession: User?
    @Published var currentUser: AppUser?
    
    private let userService = SupabaseUserService.shared
    private var cancellables: Set<AnyCancellable> = []
    
    
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
                
                self.fetchAppUser()
                
                updateUserCoordinates()
                
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
                
                
                let appUser = AppUser(
                    uid: user.id.uuidString,
                    email: email,
                    firstname: firstname,
                    lastname: lastname,
                    accountType: .rider,
                    coordinates: UserCoordinates(
                        latitude: 37.38, longitude: -122.05
                    )
                )
                
                await MainActor.run {
                    self.currentUser = appUser
                    Router.shared.reset()
                }
                
                try await SupabaseManager.table(AuthViewModel.usersTable)
                    .insert(appUser)
                    .execute()
                
                
                updateUserCoordinates()
                
                
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
                    Router.shared.reset()
                    self.userSession = nil
                    self.currentUser = nil
                    
                }
                
            } catch {
                debugPrint("Error signing out: \(error.localizedDescription)")
            }
        }
    }
    
    
    func fetchAppUser() {
        userService.$user
            .receive(on: DispatchQueue.main)
            .sink { user in
                self.currentUser = user
                self.updateUserCoordinates()
            }
            .store(in: &cancellables)
    }
    
    
    func updateUserCoordinates() {
        guard self.userSession != nil else { return }
        guard let location = LocationManager.shared.userLocation else { return }
        
        debugPrint("User location: \(location)")
        
        Task {
            do {
                
                let coordinates = UserCoordinates(
                    latitude: location.latitude,
                    longitude: location.longitude)
                
                let updateUser = UpdateUser(
                    coordinates: coordinates
                )
                
                try await SupabaseManager.table(AuthViewModel.usersTable)
                    .update(updateUser)
                    .eq("uid", value: self.userSession?.id)
                    .execute()
                
                await MainActor.run {
                    self.currentUser?.coordinates = coordinates
                }
                
            } catch {
                debugPrint("Error updating user coordinates: \(error.localizedDescription)")
            }
        }
    }
    
}

