//
//  TripRequestedView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/24/25.
//

import SwiftUI

struct TripRequestedView: View {
    @Binding var isPresented: Bool
    let trip: Trip
    
    var body: some View {
        BottomSheet(isPresented: $isPresented,
                    minHeight: UIScreen.main.bounds.height * 0.45,
                    maxHeight: UIScreen.main.bounds.height * 0.45
        ) {
            VStack {
                Text("Ride Requested")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Finding drivers nearby")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
                
                ProgressView()
                               .progressViewStyle(LinearProgressViewStyle())
                               .tint(.foreground)
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
                                    Text(trip.pickupLocation.title)
                                        .font(.system(size: 16, weight: .semibold))
                                    
                                   
                                }
                                .padding(.bottom, 10)
                                HStack {
                                    Text(trip.dropoffLocation.title)
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
            
                CustomButton(title: "CANCEL REQUEST") {
                    
                }
     
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    TripRequestedView(isPresented: .constant(true), trip: Trip.empty())
}
