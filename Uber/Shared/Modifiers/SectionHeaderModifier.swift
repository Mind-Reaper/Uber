//
//  SectionHeaderModifier.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/12/25.
//

import SwiftUI


struct SectionHeaderModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.foreground)
    }
}

extension Text {
    func sectionHeader() -> some View {
        modifier(SectionHeaderModifier())
    }
}
