//
//  UberApp.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/23/25.
//

import SwiftUI



@main
struct UberApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            HomeView()
                .background(Color.theme.backgroundColor.ignoresSafeArea())
                .environmentObject(DependencyContainer.shared.makeAuthViewModel())
                .environmentObject(DependencyContainer.shared.makeHomeViewModel())
        }
    }
}
