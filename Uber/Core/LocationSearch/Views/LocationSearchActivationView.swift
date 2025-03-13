//
//  LocationSearchActivationView.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/23/25.
//

import SwiftUI

struct LocationSearchActivationView: View {
    var body: some View {
        HStack {
            
            Image(systemName: "magnifyingglass")
        
                .font(.system(size: 18, weight: .bold))
                .padding(.leading)
            
            Text("Where to?")
                .foregroundColor(.gray)
                .fontWeight(.medium)
            
            Spacer()
        }
        .frame(
            
            height: 50
        ).background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(.systemGray5))
                .shadow(radius: 6)
        )
    }
}

#Preview {
    LocationSearchActivationView()
}
