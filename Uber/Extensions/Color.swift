//
//  Color.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/3/25.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme = ColorTheme()
    
}

struct ColorTheme {
    let backgroundColor = Color("background-color")
    let foregroundColor = Color("foreground-color")
    let buttonBackgroundColor = Color("button-background-color")
    let buttonForegroundColor = Color("button-foreground-color")
}
