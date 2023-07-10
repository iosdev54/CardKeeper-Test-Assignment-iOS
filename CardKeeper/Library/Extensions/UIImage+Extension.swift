//
//  UIImage+Extension.swift
//  CardKeeper
//
//  Created by Dmytro Grytsenko on 10.07.2023.
//

import UIKit

extension UIImage {
    
    enum AppImages {
        static let visa = UIImage(named: "visa_logo")
        static let mastercard = UIImage(named: "mastercard_logo")
    }
}

extension Optional where Wrapped == UIImage {
    
    var unwrapImage: UIImage {
        guard let image = self else { return UIImage() }
        return image
    }
}

