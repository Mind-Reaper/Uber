//
//  AcceptTripView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/17/25.
//

import SwiftUI

struct AcceptTripView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        BottomSheet(isPresented: $isPresented, minHeight: UIScreen.main.bounds.height * 0.5,
                    maxHeight: UIScreen.main.bounds.height * 0.5) {
            VStack (alignment: .leading) {
                
                // ride type
                HStack  {
                    HStack {
                        Image(systemName: "car.fill")
                            .font(.callout)
                            .foregroundStyle(.buttonForeground)
                        
                        Text("UberX")
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
                }
                .padding(.horizontal)
                
                // price and rating
                HStack  {
                    VStack (alignment: .leading) {
                        Text(
                            "$16.05"
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
                            Text("24 mins (14.4 mi) away")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.bottom, 4)
                            Text("Cabot Trl & Champlain way Rosharon")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                                .padding(.bottom, 20)
                       
                       
                            Text("18 mins (10.0 mi) trip")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.bottom, 4)
                            Text("Broadway St, Pearland")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                        
                        
                    }.padding(.leading, 8)
                } .padding()
                
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
                
                
                // pickup location info
                
                
                // action buttons
                
                
            }
        }
    }
}

#Preview {
    AcceptTripView(isPresented: .constant(true))
}
