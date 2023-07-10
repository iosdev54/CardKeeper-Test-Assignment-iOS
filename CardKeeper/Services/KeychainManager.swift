//
//  KeychainManager.swift
//  CardKeeper
//
//  Created by Dmytro Grytsenko on 10.07.2023.
//

import UIKit

class KeychainManager {
    enum KeychainError: Error {
        case saveFailed(OSStatus)
        case loadFailed(OSStatus)
        case decodeFailed
        case encodeFailed
    }
    
    static func save(key: String, cards: [Card]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(cards)
            try save(key: key, data: data)
        } catch {
            throw KeychainError.encodeFailed
        }
    }
    
    static func load(key: String) throws -> [Card] {
        guard let data = try load(key: key) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([Card].self, from: data)
        } catch {
            throw KeychainError.decodeFailed
        }
    }
    
    private static func save(key: String, data: Data) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw KeychainError.saveFailed(status)
        }
    }
    
    private static func load(key: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess {
            return result as? Data
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw KeychainError.loadFailed(status)
        }
    }
}
