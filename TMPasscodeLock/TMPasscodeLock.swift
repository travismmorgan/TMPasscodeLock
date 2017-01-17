//
//  TMPasscodeLock.swift
//  TMPasscodeLock
//
//  Created by Travis Morgan on 1/16/17.
//  Copyright © 2017 Travis Morgan. All rights reserved.
//

import UIKit

class TMPasscodeLock: NSObject {
    
    class var bundleIdentifier: String {
        get {
            return "com.travismmorgan.passcodelock"
        }
    }

    class var passcode: String? {
        get {
            return TMKeychain.load(identifier: "\(TMPasscodeLock.bundleIdentifier).passcode") as? String
        }
        set {
            if newValue != nil {
                TMKeychain.save(identifier: "\(TMPasscodeLock.bundleIdentifier).passcode", object: newValue!)
            } else {
                TMKeychain.delete(identifier: "\(TMPasscodeLock.bundleIdentifier).passcode")
            }
        }
    }
}
