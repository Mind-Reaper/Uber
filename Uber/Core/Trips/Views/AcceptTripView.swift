//
//  AcceptTripView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/17/25.
//

import SwiftUI

struct AcceptTripView: View {
    
    @Binding var trip: Trip?
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    
    var fetchedPickupRoute: Bool {
        return trip?.distanceToPickup != nil && trip?.travelTimeToPickup != nil
    }
    
    var fetchedDropoffRoute: Bool {
        return trip?.distanceToDropoff != nil && trip?.travelTimeToDropoff != nil
    }
    
    
    var body: some View {
        
        BottomSheet(isPresented: Binding<Bool>(
            get: {
                trip != nil
            }, set: { _, __ in
                
            }
        ), minHeight: UIScreen.main.bounds.height * 0.5,
                    maxHeight: UIScreen.main.bounds.height * 0.5) {
            
            if let trip = trip {
                VStack (alignment: .leading) {
                      // ride type
                    HStack  {
                        HStack {
                            Image(systemName: "car.fill")
                                .font(.callout)
                                .foregroundStyle(.buttonForeground)
                            
                            Text(trip.rideType.description)
                                .font(.headline)
                                .foregroundStyle(.buttonForeground)
                        }.padding(4)
                            .background {
                                Rectangle()
                                    .foregroundStyle(.buttonBackground)
                                    .cornerRadius(5)
                            }
                        
                        Spacer()
                        
                        Image(systemName: "xmark")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                            .background {
                                Rectangle()
                                    .foregroundStyle(Color(.systemGray5))
                                    .cornerRadius(10)
                            }
                            .onTapGesture {
                                withAnimation {
                                    homeViewModel.trip = nil
                                }
                                
                            }
                    }
                    .padding(.horizontal)
                    
                    // price and rating
                    HStack  {
                        VStack (alignment: .leading) {
                            Text(
                                trip.tripCost.toCurrency()
                            )
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                            
                            HStack  {
                                Image(systemName: "star.fill")
                                    .font(.callout)
                                Text("4.96")
                                    .fontWeight(.light)
                            }
                        }
                        
                        Spacer()
                    }.padding(.horizontal)
                    
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 1)
                    
                    // ride info
                    
                    HStack {
                        VStack{
                            Circle()
                                .fill(Color.theme.foregroundColor)
                                .frame(width: 8, height: 8)
                            Rectangle()
                                .fill(Color(.systemGray))
                                .frame(width: 1, height: 32)
                            Rectangle()
                                .fill(Color.theme.foregroundColor)
                                .frame(width: 8, height: 8)
                        }
                        
                        VStack(alignment: .leading)  {
                            Text(
                                fetchedPickupRoute ?
                                "\(trip.travelTimeToPickup!) mins (\(trip.distanceToPickup!.distanceInMilesString()) mi) away" : "Getting pickup route details..."
                            )
                                .font(.system(size: 16, weight: .semibold))
                                .italic(!fetchedPickupRoute)
                                .padding(.bottom, 4)
                            Text(trip.pickupLocation.address)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                                .padding(.bottom, 20)
                            
                            
                            Text(
                                fetchedDropoffRoute ?
                                "\(trip.travelTimeToDropoff!) mins (\(trip.distanceToDropoff!.distanceInMilesString()) mi) trip" : "Getting trip route details..."
                            )
                                .font(.system(size: 16, weight: .semibold))
                                .italic(!fetchedDropoffRoute)
                                .padding(.bottom, 4)
                            Text(trip.dropoffLocation.address)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            
                        }.padding(.leading, 8)
                    } .padding()
                    
                    // action button
                    
                    Button {
                        
                        
                        
                    } label: {
                        Text("Accept")
                            .foregroundColor(Color.theme.buttonForegroundColor)
                            .fontWeight(.bold)
                            .padding()
                            .frame(
                                maxWidth: .infinity
                            )
                            .background(Color.theme.buttonBackgroundColor)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }.padding()
                        .padding(.bottom,10)
                }
            } else {
                
            }
        }
    }
}

#Preview {
    AcceptTripView(trip: .constant(Trip.empty()))
        .environmentObject(HomeViewModel())
        
}
