//
//  UIImage+Extension.swift
//  CardKeeper
//
//  Created by Dmytro Grytsenko on 10.07.2023.
//

import UIKit

extension UIImage {
    
    enum AppImages {
        static let visa = UIImage(named: "visa_logo").unwrapImage
        static let mastercard = UIImage(named: "mastercard_logo").unwrapImage
       
        static var trash: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "trash").unwrapImage
            } else {
                return UIImage(named: "trash_icon").unwrapImage
            }
        }
    }
}

extension Optional where Wrapped == UIImage {
    
    var unwrapImage: UIImage {
        guard let image = self else {
            return UIImage()
        }
        return image
    }
}

