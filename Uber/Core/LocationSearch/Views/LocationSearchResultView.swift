//
//  LocationSearchResultView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/13/25.
//

import SwiftUI

struct LocationSearchResultView: View {
    
    @StateObject var homeViewModel: HomeViewModel
    let config: LocationResultViewConfig
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(homeViewModel.results, id: \.self) { result in
                    LocationSearchResultCell(
                        title: result.title, subtitle: result.subtitle
                    ).onTapGesture {
                        homeViewModel.selectLocation(result, config: config)
                        
                        if case .savedLocation(_) = config  {
                            dismiss()
                        }
                    }
                    .padding(.horizontal, 20)
                    
                }
            }
        }
    }
}

#Preview {
    LocationSearchResultView(
        homeViewModel: HomeViewModel(), config: .ride)
    
}
