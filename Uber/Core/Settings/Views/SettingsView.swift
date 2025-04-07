//
//  SettingsView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/12/25.
//

import SwiftUI

struct SettingsView: View {

    @EnvironmentObject private var authViewModel: AuthViewModel

    @State private var logoutAlertShown = false
    @State private var driverAlertShown = false

    var body: some View {

        if let user = authViewModel.currentUser {

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
                        ForEach(SavedLocationViewModel.allCases) { viewModel in
                            SavedLocationRowView(
                                viewModel: viewModel, user: user
                            ) {
                                Router.shared.path.append(viewModel)
                            }
                        }
                    } header: {
                        Text("Favorites").sectionHeader()
                    }

                    Section {

                        SettingsTile(icon: "bell", title: "Notifications")
                            .listRowSeparator(.hidden, edges: .top)
                        SettingsTile(
                            icon: "creditcard", title: "Payment Methods",
                            subtitle: "Add or update payment options"
                        )
                        .listRowSeparator(.hidden, edges: .bottom)

                    } header: {
                        Text("Settings").sectionHeader()
                    }

                    Section {

                        if user.accountType == .rider {
                            SettingsTile(
                                icon: "dollarsign.circle",
                                title: "Earn by driving",
                                subtitle:
                                    "Drive into financial goals. Flexible hours, competitive rates, and weekly payouts."
                            ) {
                                driverAlertShown = true
                            }
                            .listRowSeparator(.hidden, edges: .top)
                        }
                        SettingsTile(
                            icon: "rectangle.portrait.and.arrow.forward",
                            title: "Sign out"
                        ) {
                            logoutAlertShown = true
                        }.listRowSeparator(.hidden)
                        //                    listRowSeparator()

                    } header: {
                        Text("Account").sectionHeader()
                    }
                }.listStyle(InsetListStyle())

            }
            .alert(
                "Sign out",
                isPresented: $logoutAlertShown
            ) {
                Button("Yes, Sign Out", role: .destructive) {
                    logoutAlertShown = false
                    authViewModel.signout()
                }
                Button("Stay Signed In", role: .cancel) {
                    logoutAlertShown = false
                }
              
            } message: {
                Text("Are you sure you want to log out?")
            }
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
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .customBackButton()
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
