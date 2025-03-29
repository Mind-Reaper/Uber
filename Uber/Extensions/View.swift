//
//  UIView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/29/25.
//

import SwiftUI


extension View {
    func asUIImage() -> UIImage {
           let controller = UIHostingController(rootView: self)
           controller.view.backgroundColor = .clear
           
           // Get the view to calculate its own size
           controller.view.setNeedsLayout()
           controller.view.layoutIfNeeded()
           
           // Get the size of the view
           let targetSize = controller.view.intrinsicContentSize
           
           // If the intrinsic content size is not helpful, fallback to sizeThatFits
           let size = targetSize.width > 0 && targetSize.height > 0 ? targetSize : controller.view.sizeThatFits(.zero)
           
           // Update the view bounds based on the calculated size
           controller.view.bounds = CGRect(origin: .zero, size: size)
           
           // Render the view to an image
           let renderer = UIGraphicsImageRenderer(size: size)
           return renderer.image { _ in
               controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
           }
       }
       
       // Keep the original size option for cases where you need to force a specific size
       func asUIImage(size: CGSize) -> UIImage {
           let controller = UIHostingController(rootView: self)
           
           // Set the controller view size
           controller.view.bounds = CGRect(origin: .zero, size: size)
           
           // Force the controller to update its layout
           controller.view.backgroundColor = .clear
           
           let renderer = UIGraphicsImageRenderer(size: size)
           return renderer.image { _ in
               controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
           }
       }
}
