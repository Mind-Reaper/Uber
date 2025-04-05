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
    
    var body: some View {
        Color.clear.sheet(isPresented: $isPresented) {
            VStack {
                HStack {
                    Text("Meet the driver at pickup spot by \(trip.pickupLocation.title)")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    VStack {
                        Text(trip.travelTimeToPickup == nil ? "-" :  "\(trip.travelTimeToPickup!)")
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
                
                CustomButton(title: "CANCEL RIDE") {
                    homeViewModel.cancelTrip()
                }
                .padding(.horizontal)
            }
            .interactiveDismissDisabled()
                .presentationSizing(.fitted)
                .presentationDetents([.fraction(0.5)])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    TripAcceptedView(isPresented: .constant(true), trip: Trip.empty())
        .environmentObject(HomeViewModel(userService: SupabaseUserService(), tripService: SupabaseTripService()))
}
