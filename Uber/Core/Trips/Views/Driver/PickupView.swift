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
    
    var body: some View {
        
        
        
        Color.clear
            .sheet(isPresented: $isPresented) {
            VStack {
                
                HStack {
                    Text("\(trip.travelTimeToPickup ?? 0) min")
                        .font(.headline)
                    
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                        .foregroundStyle(.green)
                    
                    Text("\(trip.distanceToPickup?.distanceInMilesString() ?? "-") mi")
                        .font(.headline)
                }
                
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 2)
                
                Text(trip.riderName.uppercased())
                    .font(.title)
                    .fontWeight(.medium)
                
                
                VStack {
                    Text("Pickup at \(trip.pickupLocation.title)")

                    Text(trip.pickupLocation.address)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                
                CustomButton(title: "START TRIP", systemIcon: "arrow.right",
                             buttonColor: .green, textColor: .white
                ) {
                    
                }
                .padding(.horizontal)
                
                CustomButton(title: "CANCEL TRIP",
                             buttonColor: .red, textColor: .white
                ) {
                    
                    homeViewModel.cancelTrip()
                    
                }
                .padding(.horizontal)
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
