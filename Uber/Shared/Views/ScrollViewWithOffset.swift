//
//  ScrollViewWithOffset.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/26/25.
//

import SwiftUI

struct ScrollViewWithOffset<Content: View>: UIViewRepresentable {
    var content: Content
    @Binding var isAtTop: Bool
    
    init(isAtTop: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._isAtTop = isAtTop
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        
        // Configure scroll view
        let hostView = UIHostingController(rootView: content)
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(hostView.view)
        
        NSLayoutConstraint.activate([
            hostView.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostView.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostView.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // Update hosting controller if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isAtTop: $isAtTop)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        @Binding var isAtTop: Bool
        
        init(isAtTop: Binding<Bool>) {
            self._isAtTop = isAtTop
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // Check if at top with a small tolerance
            isAtTop = scrollView.contentOffset.y <= 0
        }
    }
}
