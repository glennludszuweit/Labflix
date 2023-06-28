//
//  Extensions.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 20/06/2023.
//

import Foundation
import UIKit
import CoreData

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension NSManagedObject {
    func setValues<T: NSManagedObject>(from object: T) {
        let keys = object.entity.attributesByName.keys
        self.setValuesForKeys(object.dictionaryWithValues(forKeys: Array(keys)))
    }
}
