//
//  Extensions.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 20/06/2023.
//

import Foundation
import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
