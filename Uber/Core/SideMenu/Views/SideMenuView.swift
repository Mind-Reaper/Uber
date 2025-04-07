//
//  SideMenuView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/8/25.
//

import SwiftUI

struct SideMenuView: View {

    
    @State private var driverAlertShown: Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel

  
    var body: some View {
        
        if let user = authViewModel.currentUser {
            
            VStack {
                // header view
                
                VStack(alignment: .leading, spacing: 32) {
                    // user info
                    UserTile(user: user)
                        .padding(.bottom)
                    
                    // become a driver
                    
                    if user.accountType == .rider {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Do more with your account")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Image(systemName: "dollarsign.circle")
                                    .font(.title2)
                                    .imageScale(.medium)
                                
                                Text("Earn By Driving")
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding()
                            }.onTapGesture {
                                driverAlertShown = true
                            }
                        }
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                Divider()
                    .padding(.bottom, 48)
                
                VStack(alignment: .leading) {
                    ForEach(SideMenuOptionViewModel.allCases) { viewModel in
                        NavigationLink(value: viewModel) {
                            SideMenuOptionView(viewModel: viewModel)
                        }
                    }
                }
                .navigationDestination(for: SideMenuOptionViewModel.self) {
                    viewModel in
                    switch viewModel {
                    case .trips:
                        Text("Trips")
                    case .wallet:
                        Text("Wallet")
                    case .settings:
                        SettingsView()
                            .applyCustomBackground()
                    case .messages:
                        Text("Messages")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                
                Spacer()
                
            }
            .padding(.vertical)
            .padding(.trailing, UIScreen.main.bounds.width - 316)
            .confirmationDialog(
                "Become a Driver",
                isPresented: $driverAlertShown
            ) {
                Button("Proceed") {
                    driverAlertShown = false
                    authViewModel.changeAccountToDriver()
                }
                Button("Not now", role: .cancel) {
                    driverAlertShown = false
                }
            } message: {
                Text(
                    "This action will convert your passenger account to a driver account. Once completed, this change cannot be reversed."
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        SideMenuView()
        .environmentObject(AuthViewModel(userService: SupabaseUserService()))
    }
}
