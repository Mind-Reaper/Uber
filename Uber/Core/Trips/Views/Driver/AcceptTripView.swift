//
//  AcceptTripView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/17/25.
//

import SwiftUI

struct AcceptTripView: View {
    
    @Binding var isPresented: Bool
    let request: TripRequest
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    
    @State var distanceToPickup: Double? = nil
    @State var travelTimeToPickup: Int? = nil
    @State var distanceToDropoff: Double? = nil
    @State var travelTimeToDropoff: Int? = nil
    
    
    var fetchedPickupRoute: Bool {
        return distanceToPickup != nil && travelTimeToPickup != nil
    }
    
    var fetchedDropoffRoute: Bool {
        return distanceToDropoff != nil && travelTimeToDropoff != nil
    }
    
    
    var body: some View {
        
        BottomSheet(isPresented: $isPresented
        , minHeight: UIScreen.main.bounds.height * 0.5,
                    maxHeight: UIScreen.main.bounds.height * 0.5) {
            
                VStack (alignment: .leading) {
                      // ride type
                    HStack  {
                        HStack {
                            Image(systemName: "car.fill")
                                .font(.callout)
                                .foregroundStyle(.buttonForeground)
                            
                            Text(request.rideType.description)
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
                                    homeViewModel.rejectTripRequest(request: request)
                                }
                                
                            }
                    }
                    .padding(.horizontal)
                    
                    // price and rating
                    HStack  {
                        VStack (alignment: .leading) {
                            Text(
                                request.tripCost.toCurrency()
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
                        .frame(height: 2)
                    
                    // ride info
                    
                    HStack {
                        VStack{
                            Circle()
                                .fill(Color.theme.foregroundColor)
                                .frame(width: 8, height: 8)
                            Rectangle()
                                .fill(Color(.systemGray))
                                .frame(width: 1, height: 40)
                            Rectangle()
                                .fill(Color.theme.foregroundColor)
                                .frame(width: 8, height: 8)
                        }
                        
                        VStack(alignment: .leading)  {
                            Text(
                                fetchedPickupRoute ?
                                "\(travelTimeToPickup!) mins (\(distanceToPickup!.distanceInMilesString()) mi) away" : "Getting pickup route details..."
                            )
                                .font(.system(size: 16, weight: .semibold))
                                .italic(!fetchedPickupRoute)
                                .padding(.bottom, 4)
                            Text(request.pickupLocation.address)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                                .padding(.bottom, 20)
                            
                            
                            Text(
                                fetchedDropoffRoute ?
                                "\(travelTimeToDropoff!) mins (\(distanceToDropoff!.distanceInMilesString()) mi) trip" : "Getting trip route details..."
                            )
                                .font(.system(size: 16, weight: .semibold))
                                .italic(!fetchedDropoffRoute)
                                .padding(.bottom, 4)
                            Text(request.dropoffLocation.address)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            
                        }.padding(.leading, 8)
                    } .padding()
                    
                    // action button
                    
                    Button {
                        homeViewModel.acceptTrip(request: request)
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
                .onAppear {
                    
                    guard let currentUser = authViewModel.currentUser else {return}
                    
                    homeViewModel.getDestinationRoute(from: currentUser.coordinates.toCLLocationCoordinate2D(), to: request.pickupLocation.toCLLocationCoordinate2D()) { route in
                        self.travelTimeToPickup = Int(route.expectedTravelTime / 60)
                        self.distanceToPickup = route.distance
                    }
                    
                    homeViewModel.getDestinationRoute(from: request.pickupLocation.toCLLocationCoordinate2D(), to: request.dropoffLocation.toCLLocationCoordinate2D()) { route in
                        self.travelTimeToDropoff = Int(route.expectedTravelTime / 60)
                        self.distanceToDropoff = route.distance
                    }
                }
        }
    }
}

//#Preview {
//    AcceptTripView(isPresented: .constant(true), request: Trip.empty())
//        .environmentObject(HomeViewModel(
//            userService: SupabaseUserService(), tripService: SupabaseTripService()
//        ))
//        
//}
