//
//  PickupView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/27/25.
//

import SwiftUI

struct PickupView: View {
    
    @Binding var isPresented: Bool
    let trip: Trip
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    @State private var confirmationPresented = false
    
    var body: some View {
        
        
        let travelTime = (trip.state == .accepted ?
                          trip.travelDetails?.travelTimeToPickup :
                            trip.travelDetails?.travelTimeToDropoff) ?? 0
        
        let travelDistance = trip.state == .accepted ?
        trip.travelDetails?.distanceToPickup :
        trip.travelDetails?.distanceToDropoff
        
        Color.clear
            .sheet(isPresented: $isPresented) {
                VStack {
                    
                    HStack {
                        Text("\(travelTime) min")
                            .font(.headline)
                        
                        Image(systemName: "person.circle.fill")
                            .font(.title)
                            .foregroundStyle(.green)
                        
                        Text("\(travelDistance?.distanceInMilesString() ?? "-") mi")
                            .font(.headline)
                    }
                    
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 2)
                    
                    Text(trip.riderName.uppercased())
                        .font(.title)
                        .fontWeight(.medium)
                    
                    
                    if trip.state == .accepted {
                        VStack {
                            Text("Pickup at \(trip.pickupLocation.title)")
                            
                            Text(trip.pickupLocation.address)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    } else {
                        VStack {
                            Text("Dropoff at \(trip.dropoffLocation.title)")
                            
                            Text(trip.dropoffLocation.address)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    
                    
                    if trip.state == .accepted {
                        CustomButton(title: "Start Trip", systemIcon: "arrow.right",
                                     buttonColor: .green, textColor: .white
                        ) {
                            
                            homeViewModel.startTrip()
                            
                        }
                        .padding(.horizontal)
                    } else {
                        CustomButton(title: "Complete Trip", systemIcon: "flag.fill"
                                
                        ) {
                            
                            homeViewModel.completeTrip()
                            
                        }
                        .padding(.horizontal)
                    }
                    
                    CustomButton(title: "Cancel Trip",
                                 buttonColor: .red, textColor: .white
                    ) {
                        
                        homeViewModel.cancelTrip()
                        
                    }
                    .padding(.horizontal)
                }
                .alert("Cancel Trip?",
                       isPresented: $confirmationPresented) {
                    Button("Yes, Cancel Trip", role: .destructive) {
                        confirmationPresented = false
                        homeViewModel.cancelTrip()
                    }
                    Button("Continue Trip", role: .cancel) {
                        confirmationPresented = false
                    }
                } message: {
                    Text("Canceling affects your acceptance rate and the rider's plans.")
                }
                .interactiveDismissDisabled()
                .presentationSizing(.fitted)
                .presentationDetents([.fraction(0.4)])
                .presentationDragIndicator(.visible)
            }
    }
}

#Preview {
    PickupView(
        isPresented: .constant(true), trip: Trip.empty()
    )
    .environmentObject(HomeViewModel(userService: SupabaseUserService(), tripService: SupabaseTripService()))
}
