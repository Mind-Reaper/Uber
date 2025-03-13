//
//  SideMenuOptionView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/8/25.
//

import SwiftUI

struct SideMenuOptionView: View {
    
    
    let viewModel: SideMenuOptionViewModel
    
    
    
    var body: some View {
        
        HStack {
            Image(systemName: viewModel.imageName)
                .font(.title2)
                .imageScale(.medium)
            
            
            Text(viewModel.title)
                .font(.system(size: 16, weight: .semibold))
                .padding()
        }
        .foregroundColor(.foreground)
        
        
    }
}

#Preview {
    SideMenuOptionView(viewModel: SideMenuOptionViewModel.trips)
}
