//
//  LocationSearchView.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/23/25.
//

import SwiftUI

struct LocationSearchView: View {
    

    @EnvironmentObject var homeViewModel: HomeViewModel
    @FocusState private var focusedField: LocationSearchViewModel?
    
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
                    TextField("Pickup Location", text: $homeViewModel.pickupQueryFragment)
                        .focused($focusedField, equals: .pickup)
                        .submitLabel(.next)
                        
                        
                    Divider()
                    TextField("Where to?", text: $homeViewModel.droppoffQueryFragment)
                        .focused($focusedField, equals: .dropoff)
                    
                        
                }.onChange(of: focusedField) { oldValue, newValue in
                    if focusedField == .pickup {
                        homeViewModel.pickupQueryFragment = homeViewModel.pickupQueryFragment
                    }
                    
                    if focusedField == .dropoff {
                        homeViewModel.droppoffQueryFragment = homeViewModel.droppoffQueryFragment
                    }
                    
                    
                }
            }
            
            .cornerRadius(10)
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.theme.foregroundColor, lineWidth: 2)
                )
            .padding(.horizontal, 20)
            
            
            // list view
            if let focusedField = focusedField {
                LocationSearchResultView(homeViewModel: homeViewModel, config: .ride(focusedField))
            } else {
                Spacer()
            }
           
            
            
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.focusedField = .dropoff
            }
        }
    }
}

#Preview {
    LocationSearchView()
        .environmentObject(HomeViewModel(
            userService: SupabaseUserService(), tripService: SupabaseTripService()
        ))
}

