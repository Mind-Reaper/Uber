//
//  LocationSearchView.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/23/25.
//

import SwiftUI

struct LocationSearchView: View {
    
    @State private var pickupLocationText: String = ""
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            // header view
            HStack {
                VStack{
                    
                    Circle()
                        .fill(Color.theme.foregroundColor)
                        .frame(width: 6, height: 6)
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(width: 1, height: 24)
                    Rectangle()
                        .fill(Color.theme.foregroundColor)
                        .frame(width: 6, height: 6)
                }
                .padding()
               
                VStack {
                    TextField("Pickup Location", text: $pickupLocationText)
                        .submitLabel(.done)
                        
                        
                    Divider()
                    TextField("Where to?", text: $homeViewModel.queryFragment)
                }
            }
            
            .cornerRadius(10)
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.theme.foregroundColor, lineWidth: 2)
                )
            .padding(.horizontal, 20)
            
            
            // list view
            
            LocationSearchResultView(homeViewModel: homeViewModel, config: .ride)
            
            
        }
    }
}

#Preview {
    LocationSearchView()
        .environmentObject(HomeViewModel(
            userService: SupabaseUserService(), tripService: SupabaseTripService()
        ))
}

