//
//  UIImage.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/29/25.
//

import Foundation
import UIKit


extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
