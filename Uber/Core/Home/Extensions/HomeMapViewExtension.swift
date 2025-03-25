//
//  HomeMapViewExtension.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/12/25.
//

import SwiftUI

extension HomeView {
    var mapView: some View {
        ZStack (alignment: .top) {
            MapViewRepresentable(mapState: $mapState)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    MapViewActionButton(
                        showSideMenu: showSideMenuBinding,
                        showBackIcon: mapState.notMainView,
                        action: mapState.notMainView ?  {
                            self.homeViewModel.selectedUberLocation = nil
                            withAnimation {
                                mapState = mapState == .locationSelected ? .searchingForLocation : .noInput
                            }
                        } : nil
                    )
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom)
                if mapState == .searchingForLocation {
                    LocationSearchView()
                }  else if mapState == .noInput && homeViewModel.trip == nil  {
                    LocationSearchActivationView()
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            withAnimation {
                                mapState = .searchingForLocation
                            }
                        }
                }
                
              
            }
            .background(mapState == .searchingForLocation ? Color.theme.backgroundColor : .clear)
            
            if let user = authViewModel.currentUser, user.accountType == .rider, homeViewModel.trip != nil {
                if mapState == .locationSelected {
                    RideRequestView()
                        .transition(.move(edge: .bottom))
                }
                
                TripRequestedView(
                    isPresented: Binding<Bool>(get: {mapState == .tripRequested}, set: { _, __ in
                        
                    }),
                    trip: homeViewModel.trip!
                )
                
                TripAcceptedView(
                    isPresented: Binding<Bool>(get: {mapState == .tripAccepted}, set: { _ in
                        
                    }),
                    trip: homeViewModel.trip!
                )
            }
            
            if authViewModel.currentUser?.accountType == .driver {
                AcceptTripView(
                    trip: $homeViewModel.trip
                )
                
            }
        }
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                homeViewModel.userLocation = location
            }
        }
        .onReceive(homeViewModel.$selectedUberLocation) { location in
            if let _ = location {
                withAnimation {
                    self.mapState = .locationSelected
                }
            }
        }
        .onReceive(homeViewModel.$trip) { trip in
            guard let trip = trip else { return }
            debugPrint("Trip State: \(trip.state)")
            withAnimation {
                switch trip.state {
                case .requested:
                    self.mapState = .tripRequested
                case .rejected:
                    self.mapState = .noInput
                case .accepted:
                    self.mapState = .tripAccepted
                }
            }
        }
    }
}
