//
//  TripRequestedView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/24/25.
//

import SwiftUI

struct TripRequestedView: View {
    @Binding var isPresented: Bool
    let tripRequest: TripRequest
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    @State private var confirmationPresented = false
    
    var body: some View {
        Color.clear.sheet(isPresented: $isPresented) {
            VStack {
                Text("Ride Requested")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Finding drivers nearby")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
                
                AnimatedLinearProgressView()
                    .frame(height: 5)
                    .padding(.bottom)
                

               
                HStack {
                    
                    VStack (alignment: .leading) {
                        Text("Ride Details")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                        
                        Text("Meetup at the pickup point")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        
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
                            
                            VStack(alignment: .leading, spacing: 24)  {
                                HStack {
                                    Text(tripRequest.pickupLocation.title)
                                        .font(.system(size: 16, weight: .semibold))
                                    
                                   
                                }
                                .padding(.bottom, 10)
                                HStack {
                                    Text(tripRequest.dropoffLocation.title)
                                        .font(.system(size: 16, weight: .semibold))
                                   
                                }
                                
                            }.padding(.leading, 8)
                        } .padding()
                        
                    }
                  
                    Spacer()
                    
                }.padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 0.5)
                }
                .padding(.bottom)
            
                CustomButton(title: "Cancel Request") {
                    confirmationPresented = true
                }
     
            }
            .padding()
            .alert("Cancel Request?",
                   isPresented: $confirmationPresented) {
                Button("Yes, Cancel", role: .destructive) {
                    confirmationPresented = false
                    homeViewModel.cancelTripReqest()
                }
                Button("Keep Searching", role: .cancel) {
                    confirmationPresented = false
                }
            } message: {
                Text("We're still searching for a driver in your area.")
            }
            .interactiveDismissDisabled()
                .presentationSizing(.fitted)
                .presentationDetents([.fraction(0.55)])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    TripRequestedView(isPresented: .constant(true), tripRequest: TripRequest.empty())
        .environmentObject(HomeViewModel(userService: SupabaseUserService(), tripService: SupabaseTripService()))
}
