//
//  SavedLocationRowView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/12/25.
//

import SwiftUI

struct SavedLocationRowView: View {
    
    let viewModel: SavedLocationViewModel
    var action: () -> Void = { }

    
    var body: some View {
        SettingsTile(icon: viewModel.icon, title: viewModel.title, subtitle: viewModel.subtitle, action: action)
          
        
            .listRowSeparator(.hidden,
                              edges: viewModel.id == 0 ? .top : viewModel.id + 1 == SavedLocationViewModel.allCases.count ? .bottom : [])
           
    }
}

#Preview {
    SavedLocationRowView(
        viewModel: .home
    )
}
