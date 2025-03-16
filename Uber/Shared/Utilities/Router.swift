//
//  Router.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/12/25.
//

import SwiftUI


class Router: ObservableObject {
    @Published  var path: NavigationPath = NavigationPath()

    static let shared: Router = Router()
    
    
    func reset() {
        path.removeLast(path.count)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    
    
}
