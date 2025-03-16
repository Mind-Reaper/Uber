//
//  SavedLocationSearchView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/12/25.
//

import SwiftUI

struct SavedLocationSearchView: View {
    
   
    
    let savedLocationViewModel: SavedLocationViewModel
    let user: AppUser
    
    
    @StateObject private var viewModel = LocationSearchViewModel()
    
   
    
    var body: some View {
        VStack {
            
            TextField("Search for a location..", text: $viewModel.queryFragment)
                .frame(height: 32)
                .padding(.horizontal)
                .cornerRadius(10)
                .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.theme.foregroundColor, lineWidth: 2)
                    )
                .padding(.horizontal, 20)
                .padding(.top)
            
            Spacer()
            
            LocationSearchResultView(viewModel: viewModel, config: .savedLocation(savedLocationViewModel))
            
        }
        .onAppear {
            self.viewModel.queryFragment = (savedLocationViewModel == .home ? user.home?.title : user.work?.title) ?? ""
        }
        .navigationTitle(savedLocationViewModel.title)
            .navigationBarTitleDisplayMode(.large)
            .customBackButton()
           
    }
        
}

#Preview {
    NavigationStack {
        SavedLocationSearchView(savedLocationViewModel: .home, user: AppUser.empty())
    }
        
}
