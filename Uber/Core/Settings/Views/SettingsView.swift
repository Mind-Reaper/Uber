//
//  SettingsView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/12/25.
//

import SwiftUI

struct SettingsView: View {
   
    private let user: AppUser
    
    @EnvironmentObject private var authViewModel: AuthViewModel
    
   
    init(user: AppUser) {
        self.user = user
    }
    
    var body: some View {
        VStack {
            List {
                Section {
                    HStack {
                        UserTile(user: user)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .imageScale(.small)
                            .font(.title2)
                            .foregroundColor(.gray)
                    }.listRowSeparator(.hidden)
                        .listRowBackground(Color.theme.backgroundColor)
                }
                
                
                Section {
                    ForEach(SavedLocationViewModel.allCases) {viewModel in
                        SavedLocationRowView(viewModel: viewModel) {
                            Router.shared.path.append(viewModel)
                        }
                    }
                } header: {
                    Text("Favorites").sectionHeader()
                }
                
                Section {
                    
                    SettingsTile(icon: "bell", title: "Notifications")
                        .listRowSeparator(.hidden, edges: .top)
                    SettingsTile(icon: "creditcard", title: "Payment Methods", subtitle: "Add or update payment options")
                        .listRowSeparator(.hidden, edges: .bottom)
                    
                } header: {
                    Text("Settings").sectionHeader()
                }
                
                Section {
                    
                    SettingsTile(icon: "dollarsign.circle", title: "Earn by driving", subtitle: "Drive into financial goals. Flexible hours, competitive rates, and weekly payouts.")
                        .listRowSeparator(.hidden, edges: .top)
                    SettingsTile(icon: "rectangle.portrait.and.arrow.forward", title: "Sign out") {
                        authViewModel.signout()
                    }.listRowSeparator(.hidden, edges: .bottom)
                        
                    
                    
                } header: {
                    Text("Account").sectionHeader()
                }
            }.listStyle(InsetListStyle())
            
        }
        .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .customBackButton()
    }
}

#Preview {
    NavigationStack {
        SettingsView(
            user: AppUser.empty()
        )
    }
}
