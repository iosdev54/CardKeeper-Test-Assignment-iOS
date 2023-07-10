//
//  CardType.swift
//  CardKeeper
//
//  Created by Dmytro Grytsenko on 10.07.2023.
//

import UIKit

enum CardType: String, CaseIterable, Codable {
    case visa = "Visa"
    case mastercard = "Mastercard"
    
    var logo: UIImage {
        switch self {
        case .visa:
            return UIImage.AppImages.visa
        case .mastercard:
            return UIImage.AppImages.mastercard
        }
    }
    
    var color: UIColor {
        switch self {
        case .visa:
            return .visaColor
        case .mastercard:
            return .mastercardColor
        }
    }
}
