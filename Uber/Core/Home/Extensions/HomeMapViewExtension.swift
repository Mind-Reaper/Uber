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
                            self.locationViewModel.selectedUberLocation = nil
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
                }  else if mapState == .noInput  {
                    LocationSearchActivationView()
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            withAnimation {
                                mapState = .searchingForLocation
                            }
                        }
                } else if mapState == .locationSelected {
                    RideRequestView()
                        .transition(.move(edge: .bottom))
                }
            }
            .background(mapState == .searchingForLocation ? Color.theme.backgroundColor : .clear)
            
        }
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                locationViewModel.userLocation = location
            }
        }
        .onReceive(locationViewModel.$selectedUberLocation) { location in
            if let _ = location {
                withAnimation {
                    self.mapState = .locationSelected
                }
            }
        }
    }
}
