//
//  TripsView.swift
//  Uber
//
//  Created by Daniel Onadipe on 4/11/25.
//

import SwiftUI

struct TripsView: View {
    
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    
    var body: some View {
        
       
        
        List {
            ForEach (Array($homeViewModel.pastTrips.enumerated()), id: \.element.id) { index, trip in
                TripHistoryView(
                    expandedView: index == 0,
                    trip: trip.wrappedValue,
                    onRebook: authViewModel.currentUser?.accountType == .driver ? nil : {
                        Router.shared.reset()
                        homeViewModel.selectedPickupLocation = trip.wrappedValue.pickupLocation
                        homeViewModel.selectedDropoffLocation = trip.wrappedValue.dropoffLocation
                    }
                )
                .listRowSeparator(index == 0 ? .hidden : .visible)
                .listRowBackground(Color.theme.backgroundColor)
            }
        }
        .listStyle(.inset)
        .navigationTitle("Activity")
        .navigationBarTitleDisplayMode(.large)
        .customBackButton()
        .onAppear {
            homeViewModel.getPastTrips()
        }
    }
}

#Preview {
    NavigationStack {
        TripsView()
            .environmentObject(AuthViewModel(userService: SupabaseUserService()))
            .environmentObject(HomeViewModel(userService: SupabaseUserService(), tripService: SupabaseTripService()))
    }
}
