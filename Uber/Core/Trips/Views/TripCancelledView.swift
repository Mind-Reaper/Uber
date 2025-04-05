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
        Color.clear.sheet(isPresented: $isPresented) {
            VStack {
                
                Text("RIDE CANCELLED")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom)

                CustomButton(title: "OK") {
                    homeViewModel.trip = nil
                }
            }.padding(.horizontal)
                .interactiveDismissDisabled()
                    .presentationSizing(.fitted)
                    .presentationDetents([.fraction(0.2)])
                    .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    TripCancelledView(isPresented: .constant(true))
        .environmentObject(HomeViewModel(
            userService: SupabaseUserService(), tripService: SupabaseTripService()
        ))
}
