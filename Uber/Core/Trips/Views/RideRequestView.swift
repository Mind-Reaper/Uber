//
//  RideRequestView.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/25/25.
//

import SwiftUI

struct RideRequestView: View {
    
    @State private var selectedRideType = RideType.uberX
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
    
            BottomSheet(
                isPresented: .constant(true),
                minHeight: UIScreen.main.bounds.height * 0.6,
                maxHeight: UIScreen.main.bounds.height * 0.85
            ) {
                VStack  {
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
                                Text("Current location")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Spacer()
                                Text(homeViewModel.pickupTime?.formattedTime ?? "")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom, 10)
                            HStack {
                                Text(homeViewModel.selectedUberLocation?.title ?? "Destination")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Spacer()
                                Text(homeViewModel.dropoffTime?.formattedTime ?? "")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                            
                        }.padding(.leading, 8)
                    } .padding()
                    
                    Divider()
                    
                    Text("Rides we think you'll like")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    VStack {
                        ForEach(RideType.allCases) { type in
                            let selected = type == selectedRideType
                            VStack {
                                if selected {  Image(type.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(
                                            height: 80
                                        )
                                }
                                HStack  {
                                    if !selected {    Image(type.image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(
                                                height: 50
                                            )
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        HStack() {
                                            Text(type.description)
                                                .font(.system(size: 16, weight: .semibold))
                                            Spacer()
                                            
                                            Text(homeViewModel.computeRidePrice(forType: type).toCurrency())
                                                .font(.system(size: 16, weight: .semibold))
                                        }
                                        
                                        
                                        Text("11:42 PM - 5 mins away")
                                            .font(.system(size: 16, weight: .regular))
                                        
                                    }.padding(.trailing)
                                    
                                    
                                }.padding(selected ? 10: 0)
                            }.overlay {
                                if selected { RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.theme.foregroundColor, lineWidth: 2)
                                }
                            }.padding(selected ? 12: 0)
                                .onTapGesture {
                                    withAnimation {
                                        selectedRideType = type
                                    }
                                }
                           
                        }
                    }
                    
                }
            } footer: {
                VStack {
                    Divider()
                    HStack(spacing: 12) {
                        Text("Visa")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(6)
                            .background(.blue)
                            .cornerRadius(4)
                            .foregroundColor(.white)
                            .padding(.leading)
                        
                        Text("**** 1234")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .imageScale(.medium)
                            .padding()
                    }
                    
                    Button {
                        homeViewModel.requestTrip(rideType: selectedRideType)
                    } label: {
                        Text("Choose \(selectedRideType.description)")
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
                    
                }.background(.ultraThickMaterial)
            }
        
        
        
    }
}

#Preview {
    RideRequestView()
}
