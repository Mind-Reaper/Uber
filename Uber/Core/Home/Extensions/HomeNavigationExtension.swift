//
//  HomeNavigationExtension.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/12/25.
//

import SwiftUI


extension View {
    func setupNavigationDestinations() -> some View {
        self
            .navigationDestination(for: AuthViewType.self) { type in
                switch type {
                case .login:
                    LoginView().applyCustomBackground()
                case .signup:
                    SignupView().applyCustomBackground()
                }
            }
            .navigationDestination(for: SavedLocationViewModel.self) { viewModel in
                SavedLocationSearchView(savedLocationViewModel: viewModel)
                    .applyCustomBackground()
            }
    }
}
