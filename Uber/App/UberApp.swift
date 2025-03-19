//
//  UberApp.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/23/25.
//

import SwiftUI



@main
struct UberApp: App {
//    @StateObject var locationViewModel: LocationSearchViewModel = .init()
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var homeViewModel: HomeViewModel = .init()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            HomeView()
                .background(Color.theme.backgroundColor.ignoresSafeArea())
//                .environmentObject(locationViewModel)
                .environmentObject(authViewModel)
                .environmentObject(homeViewModel)
        }
    }
}
