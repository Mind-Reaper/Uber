//
//  SideMenuView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/8/25.
//

import SwiftUI

struct SideMenuView: View {
    
    private let user: AppUser
    
    init(user: AppUser) {
        self.user = user
    }
    
    var body: some View {
       
            VStack {
                // header view
                
                VStack (alignment: .leading, spacing: 32) {
                    // user info
                    UserTile(user: user)
                    .padding(.bottom)
                    
                    // become a driver
                    
                    VStack (alignment: .leading, spacing: 16) {
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
                .navigationDestination(for: SideMenuOptionViewModel.self) { viewModel in
                    switch viewModel {
                    case .trips:
                        Text("Trips")
                    case .wallet:
                        Text("Wallet")
                    case .settings:
                        SettingsView(user: user)
                            .applyCustomBackground()
                    case .messages:
                        Text("Messages")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                
                Spacer()
                
            }.padding(.vertical)
            .padding(.trailing, UIScreen.main.bounds.width - 316)
    }
}

#Preview {
    NavigationStack {
        SideMenuView(
            user: AppUser.empty()
        )
    }
}
