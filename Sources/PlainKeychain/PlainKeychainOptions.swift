//
//  PlainKeychainOptions.swift
//  Created by Benjamin Barnard on 11/25/21.
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
 Options for `PlainKeychain`.
 */
public struct PlainKeychainOptions {
    
    /**
     Value supplied to `kSecAttrAccessible` when saving an item.
     */
    public let accessRequirement: AccessRequirement
    
    /**
     Value supplied to `kSecAttrSynchronizable` when saving an item.
     */
    public let iCloudEnabled: Bool
    
    
    public init(accessRequirement: AccessRequirement = .whenUnlocked,
         iCloudEnabled: Bool = false) {
        
        self.accessRequirement = accessRequirement
        self.iCloudEnabled = iCloudEnabled
        
    }
    
}

// MARK: - AccessRequirement
extension PlainKeychainOptions {
    
    /**
     Attributes that specify where and when items can be accessed.
     
     From Apple documentation: The `kSecAttrAccessible` constant is the key and its value is one of the constants defined here. When asking `SecItemCopyMatching` to return the item's data, the error `errSecInteractionNotAllowed` will be returned if the item's data is not available until a device unlock occurs.
     */
    public enum AccessRequirement {
        
        /**
         From Apple documentation: `kSecAttrAccessibleAfterFirstUnlock` Item data can only be accessed once the device has been unlocked after a restart.
         
         From Apple documentation: This is recommended for items that need to be accessible by background applications. Items with this attribute will migrate to a new device when using encrypted backups.
         */
        case afterFirstUnlock
        
        /**
         From Apple documentation: `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly` Item data can only be accessed once the device has been unlocked after a restart.
         
         From Apple documentation: This is recommended for items that need to be accessible by background applications. Items with this attribute will never migrate to a new device, so after a backup is restored to a new device these items will be missing.
         */
        case afterFirstUnlockThisDeviceOnly
                
        /**
         From Apple documentation: `kSecAttrAccessibleWhenUnlocked` Item data can only be accessed while the device is unlocked.
         
         From Apple documentation: This is recommended for items that only need be accessible while the application is in the foreground. Items with this attribute will migrate to a new device when using encrypted backups.
         */
        case whenUnlocked
        
        /**
         From Apple documentation: `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` Item data can only be accessed while the device is unlocked.
         
         From Apple documentation: This is recommended for items that only need be accessible while the application is in the foreground. Items with this attribute will never migrate to a new device, so after a backup is restored to a new device, these items will be missing.
         */
        case whenUnlockedThisDeviceOnly
        
        /**
         From Apple documentation: `kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly` Item data can only be accessed while the device is unlocked.
         
         From Apple documentation: This is recommended for items that only need to be accessible while the application is in the foreground and requires a passcode to be set on the device. Items with this attribute will never migrate to a new device, so after a backup is restored to a new device, these items will be missing. This attribute will not be available on devices without a passcode. Disabling the device passcode will cause all previously protected items to be deleted.
         */
        case whenPasscodeSetThisDeviceOnly
        
        
        /// Specifies if this access requirement limits items to the current device only.
        public var forThisDeviceOnly: Bool {
            switch self {
                case .afterFirstUnlock:
                    fallthrough
                case .whenUnlocked:
                    return false
                    
                case .afterFirstUnlockThisDeviceOnly:
                    fallthrough
                case .whenUnlockedThisDeviceOnly:
                    fallthrough
                case .whenPasscodeSetThisDeviceOnly:
                    return true
            }
        }
        
        
        /// CFString constant to be used in queries.
        internal var cfString: CFString {
            switch self {
                    
                case .afterFirstUnlock:
                    return kSecAttrAccessibleAfterFirstUnlock
                case .afterFirstUnlockThisDeviceOnly:
                    return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
                    
                case .whenUnlocked:
                    return kSecAttrAccessibleWhenUnlocked
                case .whenUnlockedThisDeviceOnly:
                    return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
                    
                case .whenPasscodeSetThisDeviceOnly:
                    return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
                    
            }
        }
    }
    
}
