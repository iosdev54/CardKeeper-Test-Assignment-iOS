//
//  Card.swift
//  CardKeeper
//
//  Created by Dmytro Grytsenko on 10.07.2023.
//

import Foundation

struct Card: Codable {
    let number: String
    let type: CardType
    let maskedNumber: String
    let dateAdded: Date
    
    init(type: CardType, number: String) {
        self.type = type
        self.number = number
        self.maskedNumber = "1111111111111111"
        self.dateAdded = Date()
    }
}
