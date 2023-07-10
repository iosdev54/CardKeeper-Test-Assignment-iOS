//
//  String+Extension.swift
//  CardKeeper
//
//  Created by Dmytro Grytsenko on 10.07.2023.
//

import Foundation

extension String {
    func formattedCardNumber() -> String {
        guard self.count == 16 else { return "Wrong number" }
        
        let maskedDigits = String(repeating: "*", count: 12)
        let lastFourDigits = String(self.suffix(4))
        let allDigits = maskedDigits + lastFourDigits
        
        let formattedNumber = allDigits.chunkFormatted(withChunkSize: 4, withSeparator: " ")
        return formattedNumber
    }
    
    private func chunkFormatted(withChunkSize chunkSize: Int, withSeparator separator: String) -> String {
        let formattedString = self
            .enumerated()
            .map { $0.offset % chunkSize == 0 ? "\(separator)\($0.element)" : String($0.element) }
            .joined()
            .trimmingCharacters(in: CharacterSet(charactersIn: separator))
        
        return formattedString
    }
}
