//
//  PlainKeychainError.swift
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

public enum PlainKeychainError: LocalizedError {
    
    case conversionError
    case itemAlreadyExists
    case unexpectedItemData
    case otherError(status: OSStatus)
    
    public var errorDescription: String? {
        if #available(iOS 11.3, tvOS 11.3, watchOS 4.3, *) {
            
            switch self {
                case .otherError(let status):
                    // TODO: Localize
                    return "Keychain: \(SecCopyErrorMessageString(status, nil) as String? ?? "Unknown error")"
                default:
                    return nil
            }
            
        } else {
            return nil
        }
    }
}
