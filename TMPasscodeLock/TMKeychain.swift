//
//  TMKeychain.swift
//  Vayl
//
//  Created by Travis Morgan on 10/29/15.
//  Copyright © 2015 vayl. All rights reserved.
//

import UIKit
import Security

let kSecClassValue = NSString(format: kSecClass)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecAttrAccessibleValue = NSString(format: kSecAttrAccessible)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)

let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrAccessibleAfterFirstUnlockValue = NSString(format: kSecAttrAccessibleAfterFirstUnlock)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

class TMKeychain {
    
    private class func getKeychainQuery(identifier: String) -> NSMutableDictionary {
        return NSMutableDictionary(objects: [kSecClassGenericPasswordValue, identifier, identifier, kSecAttrAccessibleAfterFirstUnlockValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecAttrAccessibleValue])
    }
    
    class func save(identifier: String, object: Any) {
        let keychainQuery: NSMutableDictionary = getKeychainQuery(identifier: identifier)
        
        SecItemDelete(keychainQuery as CFDictionary)
        
        keychainQuery.setObject(NSKeyedArchiver.archivedData(withRootObject: object), forKey: kSecValueDataValue)
        
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    class func load(identifier: String) -> Any? {
        let keychainQuery = getKeychainQuery(identifier: identifier)
        keychainQuery.setObject(kCFBooleanTrue, forKey: kSecReturnDataValue)
        keychainQuery.setObject(kSecMatchLimitOneValue, forKey: kSecMatchLimitValue)
        
        var dataTypeRef: AnyObject?
        
        let status: OSStatus = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(keychainQuery as CFDictionary, UnsafeMutablePointer($0)) }
        
        if status == noErr {
            if let data = dataTypeRef as? Data {
                return NSKeyedUnarchiver.unarchiveObject(with: data)
            }
        }
        
        return nil
    }
    
    class func delete(identifier: String) {
        let keychainQuery = getKeychainQuery(identifier: identifier)
        SecItemDelete(keychainQuery as CFDictionary)
    }

}
