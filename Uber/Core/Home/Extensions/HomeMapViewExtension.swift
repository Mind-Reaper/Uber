//
//  HomeMapViewExtension.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/12/25.
//

import SwiftUI
import Combine

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
                            
                            withAnimation {
                                mapState = mapState == .locationSelected ? .searchingForLocation : .noInput
                            }
                            if mapState == .noInput {
                                self.homeViewModel.selectedDropoffLocation = nil
                            }
                        } : nil
                    )
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom)
                if mapState == .searchingForLocation {
                    LocationSearchView()
                }  else if mapState == .noInput && authViewModel.currentUser?.accountType == .rider  {
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
            
            
            let user = authViewModel.currentUser

            let isRider = user?.accountType == .rider
            let isDriver = user?.accountType == .driver
            
            
            let trip = homeViewModel.trip
            let driverRequests = homeViewModel.driverRequests
            let riderRequest = homeViewModel.riderRequest
            
            
            RideRequestView(
                isPresented: (mapState == .locationSelected && isRider).asBinding
            )
            
            TripRequestedView(
                isPresented: (mapState == .tripRequested && riderRequest != nil && isRider)
                    .asBinding,
                tripRequest: riderRequest ?? TripRequest.empty()
            )
            
            TripAcceptedView(
                isPresented: (mapState == .tripAccepted && trip != nil && isRider).asBinding,
                trip: trip ?? Trip.empty()
            )
            
            
            TripCancelledView(
                isPresented: (mapState == .tripCancelled).asBinding
            )
            
            
            AcceptTripView(
                isPresented: (mapState == .tripRequested && !driverRequests.isEmpty && isDriver)
                    .asBinding,
                request: driverRequests.first ?? TripRequest.empty()
            )
            
            PickupView(
                isPresented: (mapState == .tripAccepted && trip != nil && isDriver)
                    .asBinding,
                trip: trip ?? Trip.empty()
            )
            
            
            
            
            
//            if let user = authViewModel.currentUser, user.accountType == .rider {
//                if mapState == .locationSelected {
////                    RideRequestView()
////                        .transition(.move(edge: .bottom))
//                } else if homeViewModel.riderRequest != nil {
//                    TripRequestedView(
//                        isPresented: Binding<Bool>(get: {mapState == .tripRequested}, set: { _, __ in
//                            
//                        }),
//                        tripRequest: homeViewModel.riderRequest!
//                    )
//                    
//                } else if homeViewModel.trip != nil {
//                    
//                    TripAcceptedView(
//                        isPresented: Binding<Bool>(get: {mapState == .tripAccepted}, set: { _ in
//                            
//                        }),
//                        trip: homeViewModel.trip!
//                    )
//                    
//                    
//                    TripCancelledView(isPresented: Binding<Bool>(get: {mapState == .tripCancelled}, set: { _ in
//                        
//                    }))
//                }
//            }
//            
//            if authViewModel.currentUser?.accountType == .driver, !homeViewModel.driverRequests.isEmpty {
//                AcceptTripView(
//                    isPresented:  Binding<Bool>(get: {mapState == .tripRequested}, set: { _, __ in
//                        
//                    }),
//                    request: homeViewModel.driverRequests.first!
//                )
//                
//                if (homeViewModel.trip != nil) {
//                    PickupView(
//                        isPresented:  Binding<Bool>(get: {mapState == .tripAccepted}, set: { _, __ in
//                            
//                        }),
//                        trip: homeViewModel.trip!
//                    )
//                    
//                    TripCancelledView(isPresented: Binding<Bool>(get: {mapState == .tripCancelled}, set: { _ in
//                        
//                    }))
//                }
//                
//               
//                
//            }
        }
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                homeViewModel.userLocation = location
            }
        }
        .onReceive(Publishers.CombineLatest( homeViewModel.$selectedPickupLocation, homeViewModel.$selectedDropoffLocation)) { pickup, dropoff in
            
            if pickup != nil && dropoff != nil {
                withAnimation {
                    self.mapState = .locationSelected
                }
            }
        }
        .onReceive(homeViewModel.$trip) { trip in
            withAnimation {
                guard let trip = trip else {
                    self.mapState = .noInput
                    return
                }
            debugPrint("Trip State: \(trip.state)")
                switch trip.state {
                case .completed:
                    self.mapState = .noInput
                case .accepted, .ongoing:
                    self.mapState = .tripAccepted
                case .cancelled:
                    self.mapState = .tripCancelled
                }
            }
        }
        .onReceive(Publishers.CombineLatest( homeViewModel.$riderRequest, homeViewModel.$driverRequests)) { riderRequest, driverRequests in
           
            guard let user = authViewModel.currentUser else { return }
            
            if user.accountType == .rider, riderRequest?.state == .requested {
                self.mapState = .tripRequested
            }
            
            if user.accountType == .driver, !driverRequests.isEmpty {
                self.mapState = .tripRequested
            }
                
              
           
        }
    }
}
