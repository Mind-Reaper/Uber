//
//  TripCancelledView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/27/25.
//

import SwiftUI

struct TripCancelledView: View {
    
    @Binding var isPresented: Bool
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        BottomSheet(isPresented: $isPresented,
                    minHeight: UIScreen.main.bounds.height * 0.2,
                    maxHeight: UIScreen.main.bounds.height * 0.2,
                    content: {
            VStack {
                
                Text("RIDE CANCELLED")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom)

                CustomButton(title: "OK") {
                    homeViewModel.trip = nil
                }
            }.padding(.horizontal)
        }) {
            
        }
    }
}

#Preview {
    TripCancelledView(isPresented: .constant(true))
        .environmentObject(HomeViewModel(
            userService: SupabaseUserService(), tripService: SupabaseTripService()
        ))
}
