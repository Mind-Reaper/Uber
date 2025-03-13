//
//  BackButton.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/12/25.
//

import SwiftUI



struct BackButton: ViewModifier {
    
    @Environment(\.dismiss) var dismiss
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.foreground)
                    }
                }
            }
    }
}


extension View {
    func customBackButton() -> some View {
        self.modifier(BackButton())
    }
}
