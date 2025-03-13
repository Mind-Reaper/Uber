//
//  HomeSideMenuBindingExtension.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/12/25.
//

import SwiftUI



extension HomeView {
     var showSideMenuBinding: Binding<Bool> {
        Binding (
            get: { self.showSideMenu },
            set: { newValue in
                withAnimation {
                    self.showSideMenu = newValue
                    if newValue {
                        self.offset = 316
                    } else {
                        self.offset = 0
                    }
                }
            }
        )
    }
}
