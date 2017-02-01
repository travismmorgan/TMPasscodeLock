//
//  TMPasscodeLock.swift
//  TMPasscodeLock
//
//  Created by Travis Morgan on 1/16/17.
//  Copyright © 2017 Travis Morgan. All rights reserved.
//

import UIKit

public class TMPasscodeLock: NSObject {
    
    public class var isPasscodeSet: Bool {
        get {
            return TMPasscodeLock.passcode != nil
        }
    }
    
    class var bundleIdentifier: String {
        get {
            return "com.travismmorgan.passcodelock"
        }
    }

    class var passcode: String? {
        get {
            return UserDefaults.standard.string(forKey: "\(TMPasscodeLock.bundleIdentifier).passcode")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "\(TMPasscodeLock.bundleIdentifier).passcode")
        }
    }
}
