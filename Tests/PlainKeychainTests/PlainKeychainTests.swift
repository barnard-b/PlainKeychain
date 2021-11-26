//
//  PlainKeychainTests.swift
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

import XCTest
@testable import PlainKeychain

final class PlainKeychainTests: XCTestCase {
    
    func testStoreRetrieveAndUpdate() {
        
        let allAccessRequirements: [PlainKeychainOptions.AccessRequirement] = [
            .whenUnlocked,
            .whenUnlockedThisDeviceOnly,
            .afterFirstUnlock,
            .afterFirstUnlockThisDeviceOnly,
            .whenPasscodeSetThisDeviceOnly,
        ]
        
        for requirement in allAccessRequirements {
        
            do {
            
                let options = PlainKeychainOptions(accessRequirement: requirement)
                let keychain = PlainKeychain(service: "testStoreRetrieveAndUpdate", options: options)
                
                let key = "username"
                let value = "example@example.com"
                try keychain.setString(value, forKey: key)
                XCTAssertEqual(try keychain.getString(forKey: key), value)
                
                let secondValue = "bob@example.com"
                try keychain.setString(secondValue, forKey: key)
                XCTAssertEqual(try keychain.getString(forKey: key), secondValue)
                
                try keychain.deleteString(forKey: key)
                
            } catch {
                XCTFail(error.localizedDescription)
            }
            
        }
        
    }
    
    func testDelete() {
        
        do {
            
            let keychain = PlainKeychain(service: "testDelete")
            
            let key = "password"
            let value = "123456<-NeverUseThisPassword😱"
            
            try keychain.setString(value, forKey: key)
            XCTAssertEqual(try keychain.getString(forKey: key), value)
            
            try keychain.deleteString(forKey: key)
            XCTAssertNil(try keychain.getString(forKey: key))
        
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
}
