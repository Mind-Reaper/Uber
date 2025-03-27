//
//  AnimatedLinearProgressView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/26/25.
//

import SwiftUI

struct AnimatedLinearProgressView: View {
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                
                // Animated progress indicator
                Rectangle()
                    .fill(Color.theme.foregroundColor)
                    .cornerRadius(10)
                    .frame(width: isAnimating ? geometry.size.width * 0.3 : 0)
                    .offset(x: isAnimating ? geometry.size.width * 0.7 : 0)
                    .animation(
                        Animation.linear(duration: 1.0)
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
            .onAppear {
                isAnimating = true
            }
        }
    }
}



#Preview {
    VStack {
        AnimatedLinearProgressView()
            
    }
}
