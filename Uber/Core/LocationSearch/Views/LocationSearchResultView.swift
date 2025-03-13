//
//  LocationSearchResultView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/13/25.
//

import SwiftUI

struct LocationSearchResultView: View {
    
    @StateObject var viewModel: LocationSearchViewModel
    let config: LocationResultViewConfig
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.results, id: \.self) { result in
                    LocationSearchResultCell(
                        title: result.title, subtitle: result.subtitle
                    ).onTapGesture {
                        viewModel.selectLocation(result, config: config)
                    }
                    .padding(.horizontal, 20)
                    
                }
            }
        }
    }
}

#Preview {
    LocationSearchResultView(
        viewModel: LocationSearchViewModel(), config: .ride)
    
}
