//
//  HomeView.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/23/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State internal var mapState = MapViewState.noInput
    @State internal var showSideMenu = false
    @State internal var offset: CGFloat = 0
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    @StateObject var router = Router.shared
    
    
    var body: some View {
    
            NavigationStack(path: $router.path) {
                Group {
                    if authViewModel.userSession == nil {
                        LoginView()
                        
                    } else if let user = authViewModel.currentUser {
                        
                        ZStack {
                            SideMenuView(user: user)
                                .background(Color(.background))
                                .simultaneousGesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            if gesture.translation.width < 0 {
                                                self.offset = 316 + gesture.translation.width
                                            }
                                        }
                                        .onEnded { gesture in
                                            
                                            if gesture.translation.width < -200 {
                                                showSideMenuBinding.wrappedValue.toggle()
                                            } else {
                                                withAnimation {
                                                    self.offset = 316
                                                }
                                            }
                                        }
                                )
                            mapView.offset(x: offset)
                                .shadow(color: showSideMenu ? .black.opacity(0.2) : .clear, radius: 10)
                        }
                    }
                }
                .setupNavigationDestinations(authViewModel.currentUser)
            }
            .scrollContentBackground(.hidden)
    }
}












#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(LocationSearchViewModel())
}
