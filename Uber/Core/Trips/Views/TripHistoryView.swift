//
//  TripHistoryView.swift
//  Uber
//
//  Created by Daniel Onadipe on 4/12/25.
//

import SwiftUI

struct TripHistoryView: View {

    var expandedView: Bool = false
    let trip: Trip

    var onRebook: (() -> Void)?

    var body: some View {
        
        
        let tripCost = (trip.state == .cancelled ? 0 : trip.tripCost).toCurrency()
        
        if expandedView {

            VStack(alignment: .leading) {
                RouteMapView(
                    pickupLocation: trip.pickupLocation,
                    dropoffLocation: trip.dropoffLocation
                )
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                Text(trip.dropoffLocation.title)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(
                    "\(trip.createdAt.formattedDate) • \(trip.createdAt.formattedTime)"
                )
                .foregroundStyle(.gray)

                Text("\(tripCost)\(trip.state == .cancelled ? " • Canceled" : "")")
                    .foregroundStyle(.gray)
                    .padding(.bottom)

                rebookButton

            }.padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 2)
                }

        } else {
            HStack(spacing: 0) {

                Image(trip.rideType.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)

                VStack(alignment: .leading) {
                    Text(trip.dropoffLocation.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(
                        "\(trip.createdAt.formattedDate) • \(trip.createdAt.formattedTime)"
                    )
                    .font(.caption)
                    .foregroundStyle(.gray)

                   
                        Text("\(tripCost)\(trip.state == .cancelled ? " • Canceled" : "")")
                            .font(.caption)
                           .foregroundStyle(.gray)
                        
                     
                    .font(.caption)

                }
                .padding(.trailing)

                Spacer()

                rebookButton

            }
        }
    }

    var rebookButton: some View {
        Group {
            if let onRebook = onRebook {
                Button {
                    onRebook()
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .foregroundStyle(Color.theme.foregroundColor)
                        Text("Rebook")
                            .foregroundStyle(Color.theme.foregroundColor)
                    }
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background {
                        Rectangle()
                            .cornerRadius(20)
                            .foregroundStyle(Color(.systemGray5))
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
}

#Preview {
    TripHistoryView(
        expandedView: false,
        trip: Trip.empty()
    )
    //    .applyCustomBackground()
    .environmentObject(
        HomeViewModel(
            userService: SupabaseUserService(),
            tripService: SupabaseTripService()))
}
