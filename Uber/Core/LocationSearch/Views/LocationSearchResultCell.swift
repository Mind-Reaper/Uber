//
//  LocationSearchResultCell.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/23/25.
//

import SwiftUI

struct LocationSearchResultCell: View {
    
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
            
            VStack (alignment: .leading) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.gray)
                
                Divider()
                
            }.padding(.leading)
           
        }
    }
}

#Preview {
    LocationSearchResultCell(
        title: "The Drake's Court", subtitle: "3 Ajifoluke Ave, Lekki, Lagos State."
    )
}
