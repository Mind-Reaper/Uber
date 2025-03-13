//
//  BackgroundColor.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/12/25.
//

import SwiftUI


extension View {
  func applyCustomBackground() -> some View {
      ZStack {
          Color.theme.backgroundColor.ignoresSafeArea()
          self
      }
    }
}
