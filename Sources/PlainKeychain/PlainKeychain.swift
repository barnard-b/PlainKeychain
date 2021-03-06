//
//  PlainKeychain.swift
//  Created by Benjamin Barnard on 11/24/21.
//
//  Copyright 2021 Benjamin Barnard.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation

/**
 A really simple key-value wrapper for keychain.
 */
public struct PlainKeychain {
    
    private let service: String
    private let options: PlainKeychainOptions
    
    /**
     A really simple key-value wrapper for keychain.
     
     - parameter options: Options to use for this keychain.
     - parameter service: `kSecAttrService`: An identifier that helps separate items based on the service they are for.
     */
    public init(service: String, options: PlainKeychainOptions = .init()) {
        self.service = service
        self.options = options
    }
    
    /**
     Creates or updates the string with the specified key.
     */
    public func setString(_ value: String, forKey key: String) throws {
        
        guard let valueData = value.data(using: .utf8) else {
            throw PlainKeychainError.conversionError
        }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccessible: options.accessRequirement.cfString,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecValueData: valueData,
            kSecAttrSynchronizable: options.iCloudEnabled
        ]
        
        if options.iCloudEnabled && options.accessRequirement.forThisDeviceOnly {
            assertionFailure("Items stored or obtained using the kSecAttrSynchronizable key may not also specify a kSecAttrAccessible value that is incompatible with syncing (namely, those whose names end with ThisDeviceOnly.). Disable iCloudEnabled or choose a different accessRequirement.")
        }
            
        do {
            
            let addStatus = SecItemAdd(query as CFDictionary, nil)
            
            if addStatus == errSecDuplicateItem {
                throw PlainKeychainError.itemAlreadyExists
            }
            
            guard addStatus == errSecSuccess else {
                throw PlainKeychainError.otherError(status: addStatus)
            }
            
        } catch PlainKeychainError.itemAlreadyExists {
            
            try deleteString(forKey: key)
            try setString(value, forKey: key)
            
        }
    }
    
    /**
     Gets the string for the specified key.
     */
    public func getString(forKey key: String) throws -> String? {
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true,
            kSecReturnAttributes: true
        ]
        
        
        var rawItem: CFTypeRef?
        let getStatus = SecItemCopyMatching(query as CFDictionary, &rawItem)
        
        if getStatus == errSecItemNotFound {
            return nil
        }
        
        guard getStatus == errSecSuccess else {
            throw PlainKeychainError.otherError(status: getStatus)
        }
        
        guard let item = rawItem as? [String: Any],
              let itemData = item[kSecValueData as String] as? Data,
              let itemString = String(data: itemData, encoding: .utf8) else {
            throw PlainKeychainError.unexpectedItemData
        }
        
        return itemString
        
    }
    
    /**
     Removes the string for the specified key.
     */
    public func deleteString(forKey key: String) throws {
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecReturnAttributes: true
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw PlainKeychainError.otherError(status: status)
        }
        
    }

}
