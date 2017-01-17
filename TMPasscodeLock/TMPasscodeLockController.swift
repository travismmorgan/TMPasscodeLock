//
//  TMPasscodeLockController.swift
//  TMPasscodeLock
//
//  Created by Travis Morgan on 1/16/17.
//  Copyright © 2017 Travis Morgan. All rights reserved.
//

import UIKit

public enum TMPasscodeLockState {
    case enter
    case set
    case change
    case remove
}

public enum TMPasscodeLockStyle {
    case basic
}

public protocol TMPasscodeLockControllerDelegate: class {
    func passcodeLockController(passcodeLockController: TMPasscodeLockController, didFinishFor state: TMPasscodeLockState)
    func passcodeLockControllerDidCancel(passcodeLockController: TMPasscodeLockController)
}

public class TMPasscodeLockController: NSObject, TMPasscodeLockViewControllerDelegate {
    
    public weak var delegate: TMPasscodeLockControllerDelegate?
    
    public var style: TMPasscodeLockStyle = .basic
    public var state: TMPasscodeLockState = .set
    public var isPresented: Bool {
        get {
            return rootViewController != nil
        }
    }
    
    fileprivate var passcodeLockViewController: TMPasscodeLockViewController?
    fileprivate var mainWindow: UIWindow?
    fileprivate var rootViewController: UIViewController?
    
    public convenience init(style: TMPasscodeLockStyle, state: TMPasscodeLockState) {
        self.init()
        
        self.style = style
        self.state = state
    }

    public func presentIn(window: UIWindow, animated: Bool) {
        guard !isPresented else { return }
        if (state != .set) && !TMPasscodeLock.isPasscodeSet {
            print("Passcode not set")
            return
        }
        
        mainWindow = window
        rootViewController = mainWindow?.rootViewController
        
        passcodeLockViewController = TMPasscodeLockViewController(style: style, state: state)
        passcodeLockViewController?.delegate = self
        
        if animated {
            UIView.transition(with: window, duration: CATransaction.animationDuration(), options: .transitionCrossDissolve, animations: {
                self.mainWindow?.rootViewController = UINavigationController(rootViewController: self.passcodeLockViewController!)
            }, completion: nil)
        } else {
            self.mainWindow?.rootViewController = UINavigationController(rootViewController: passcodeLockViewController!)
        }
    }
    
    public func presentIn(viewController: UIViewController, animated: Bool) {
        passcodeLockViewController = TMPasscodeLockViewController(style: style, state: state)
        passcodeLockViewController?.delegate = self
        viewController.present(UINavigationController(rootViewController: passcodeLockViewController!), animated: animated, completion: nil)
    }
    
    public func dismiss(animated: Bool) {
        
        if mainWindow != nil {
            if animated {
                UIView.transition(from: self.mainWindow!.rootViewController!.view, to: self.rootViewController!.view, duration: CATransaction.animationDuration(), options: .transitionCrossDissolve, completion: { (finished) in
                    if finished {
                        self.mainWindow?.rootViewController = self.rootViewController
                        self.mainWindow = nil
                        self.rootViewController = nil
                        self.passcodeLockViewController = nil
                    }
                })
            } else {
                mainWindow?.rootViewController = rootViewController
                mainWindow = nil
                rootViewController = nil
                passcodeLockViewController = nil
            }
        } else {
            passcodeLockViewController?.dismiss(animated: animated, completion: nil)
        }
    }
    
    func passcodeLockViewControllerDidCancel() {
        delegate?.passcodeLockControllerDidCancel(passcodeLockController: self)
        dismiss(animated: true)
    }
    
    func passcodeLockViewControllerDidFinish(state: TMPasscodeLockState) {
        delegate?.passcodeLockController(passcodeLockController: self, didFinishFor: state)
        dismiss(animated: true)
    }
}
