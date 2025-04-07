//
//  TripAcceptedView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/25/25.
//

import SwiftUI

struct TripAcceptedView: View {
    
    @Binding var isPresented: Bool
    let trip: Trip
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    @State private var confirmationPresented = false
    
    
    
    var body: some View {
        
        let travelTime = trip.state == .accepted ? trip.travelDetails?.travelTimeToPickup : trip.travelDetails?.travelTimeToDropoff
        
        Color.clear.sheet(isPresented: $isPresented) {
        
            VStack {
                HStack {
                    Text(
                        trip.state == .accepted ?
                        "Meet the driver at pickup spot by \(trip.pickupLocation.title)" :
                            "Heading to \(trip.dropoffLocation.title)"
                    )
                    .font(.title3)
                    .fontWeight(.semibold)
                    Spacer()
                    VStack {
                        Text(travelTime == nil ? "-" :  "\(travelTime!)")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("min")
                        
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                    .foregroundStyle(.buttonForeground)
                    .background(.buttonBackground)
                }.padding(.horizontal)
                
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 2)
                
                VStack() {
                    
                    ZStack {
                        HStack {
                            Spacer()
                            Image("sonata")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 70)
                        }
                        HStack {
                            Image("male-profile-photo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(Color.theme.backgroundColor, lineWidth: 2)
                                }
                            Spacer()
                        }
                    }
                    .frame(maxWidth: 170, alignment: .center)
                    .padding(.bottom)
                    
                    Text("6Z46dJ1".uppercased())
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text("Blue Hyundai Sonata")
                        .fontWeight(.semibold)
                    
                    
                }
                .padding(.bottom)
                
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 2)
                    .padding(.bottom)
                
                CustomButton(title: "Cancel Ride") {
                    confirmationPresented = true
                }
                .padding(.horizontal)
                .alert("Cancel Ride?",
                       isPresented: $confirmationPresented) {
                    Button("Yes, Cancel Ride", role: .destructive) {
                        confirmationPresented = false
                        homeViewModel.cancelTrip()
                    }
                    Button("No, Keep Ride", role: .cancel) {
                        confirmationPresented = false
                    }
                } message: {
                    Text("Are you sure you want to cancel this ride? Cancellation fees may apply based on our policy.")
                }
            }
           
            .interactiveDismissDisabled()
            .presentationSizing(.fitted)
            .presentationDetents([.fraction(0.55)])
            .presentationDragIndicator(.visible)
        }
        
    }
}

#Preview {
    TripAcceptedView(isPresented: .constant(true), trip: Trip.empty())
        .environmentObject(HomeViewModel(userService: SupabaseUserService(), tripService: SupabaseTripService()))
}
