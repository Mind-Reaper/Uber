//
//  MapViewActionButton.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/23/25.
//

import SwiftUI

struct MapViewActionButton: View {
    
    @Binding  var showSideMenu: Bool
    
    let showBackIcon: Bool
    var action: (() -> Void)?
    
    
    
    var body: some View {
        Button {
            if let action = action {
                action()
            } else {
//                withAnimation {
                    showSideMenu.toggle()
//                }
               
            }
        } label:  {
            Image(systemName:  showBackIcon ? "arrow.left" : "line.3.horizontal")
                .font(.title2)
                .foregroundColor(Color.theme.foregroundColor)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .shadow(radius: 6)
        }
        .frame( alignment: .leading)
    }
}

#Preview {
    MapViewActionButton(showSideMenu: .constant(false) ,showBackIcon: false)
}
