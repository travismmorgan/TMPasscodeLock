//
//  TMPasscodeLockViewController.swift
//  TMPasscodeLock
//
//  Created by Travis Morgan on 1/16/17.
//  Copyright © 2017 Travis Morgan. All rights reserved.
//

import UIKit

protocol TMPasscodeLockViewControllerDelegate: class {
    func passcodeLockViewControllerDidFinish(state: TMPasscodeLockState)
    func passcodeLockViewControllerDidCancel()
}

class TMPasscodeLockViewController: UIViewController {
    
    @IBOutlet var instructionLabel: UILabel!
    @IBOutlet var errorView: UIView!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var dot1: UIView!
    @IBOutlet var dot2: UIView!
    @IBOutlet var dot3: UIView!
    @IBOutlet var dot4: UIView!
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var leadingConstraint: NSLayoutConstraint!

    var delegate: TMPasscodeLockViewControllerDelegate?
    var style: TMPasscodeLockStyle = .basic
    var state: TMPasscodeLockState = .set
    var passcode: String?
    var newPasscode: String?
    
    convenience init(style: TMPasscodeLockStyle, state: TMPasscodeLockState) {
        self.init(nibName: "TMBasicViewController", bundle: Bundle(for: TMPasscodeLockViewController.self))

        self.style = style
        self.state = state
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if state != .enter {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        }
        
        switch state {
        case .enter:
            navigationItem.title = "Enter Passcode"
            instructionLabel.text = "Enter your passcode"
            break
        case .set:
            navigationItem.title = "Set Passcode"
            instructionLabel.text = "Enter a passcode"
            break
        case .change:
            navigationItem.title = "Change Passcode"
            instructionLabel.text = "Enter your old passcode"
            break
        case .remove:
            navigationItem.title = "Remove Passcode"
            instructionLabel.text = "Enter your passcode"
            break
        }
        
        textField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillChangeFrame(notification: Notification) {
        var info = notification.userInfo
        let kbSize = (info![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        
        if kbSize.height != bottomConstraint.constant {
            bottomConstraint.constant = kbSize.height
            view.layoutIfNeeded()
        }
    }
    
    func cancel() {
        textField.resignFirstResponder()
        delegate?.passcodeLockViewControllerDidCancel()
    }

    func checkPasscode(code: String) {
        switch state {
            
        case .enter:
            
            if code == TMPasscodeLock.passcode {
                delegate?.passcodeLockViewControllerDidFinish(state: state)
            } else {
                showError(message: "Passcode Incorrect")
            }
            break
            
        case .set:
            
            if passcode == nil {
                passcode = code
                
                self.leadingConstraint.constant = -self.view.frame.width
                
                UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0, options: .curveEaseOut, animations: {
                    
                    self.view.layoutIfNeeded()
                    
                }, completion: { (finished) in
                    
                    self.leadingConstraint.constant = self.view.frame.width
                    self.view.layoutIfNeeded()
                    self.clearPasscode()
                    self.instructionLabel.text = "Verify your new passcode"
                    self.errorView.isHidden = true
                    self.leadingConstraint.constant = 0
                    UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0, options: .curveEaseOut, animations: {
                        self.view.layoutIfNeeded()
                        
                    }, completion: nil)
                })
            } else {
                if code == passcode {
                    
                    TMPasscodeLock.passcode = code
                    textField.resignFirstResponder()
                    delegate?.passcodeLockViewControllerDidFinish(state: state)
                    
                } else {
                    
                    passcode = nil
                    
                    self.leadingConstraint.constant = self.view.frame.width
                    
                    UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0, options: .curveEaseOut, animations: {
                        
                        self.view.layoutIfNeeded()
                        
                    }, completion: { (finished) in
                        
                        self.leadingConstraint.constant = -self.view.frame.width
                        self.view.layoutIfNeeded()
                        self.instructionLabel.text = "Enter a passcode"
                        self.showError(message: "Passcodes did not match")
                        self.leadingConstraint.constant = 0
                        UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0, options: .curveEaseOut, animations: {
                            self.view.layoutIfNeeded()
                            
                        }, completion: nil)
                    })
                    
                }
            }
            
            break
        case .change:
            
            if passcode == nil {
                
                if code == TMPasscodeLock.passcode {
                    
                    passcode = code
                    
                    self.leadingConstraint.constant = -self.view.frame.width
                    
                    UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0, options: .curveEaseOut, animations: {
                        
                        self.view.layoutIfNeeded()
                        
                    }, completion: { (finished) in
                        
                        self.leadingConstraint.constant = self.view.frame.width
                        self.view.layoutIfNeeded()
                        self.clearPasscode()
                        self.instructionLabel.text = "Enter your new passcode"
                        self.errorView.isHidden = true
                        self.leadingConstraint.constant = 0
                        UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0, options: .curveEaseOut, animations: {
                            self.view.layoutIfNeeded()
                            
                        }, completion: nil)
                    })
                } else {
                    self.showError(message: "Passcode Incorrect")
                }
                
            } else {
                if newPasscode == nil {
                    
                    newPasscode = code
                    
                    self.leadingConstraint.constant = -self.view.frame.width
                    
                    UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0, options: .curveEaseOut, animations: {
                        
                        self.view.layoutIfNeeded()
                        
                    }, completion: { (finished) in
                        
                        self.leadingConstraint.constant = self.view.frame.width
                        self.view.layoutIfNeeded()
                        self.clearPasscode()
                        self.instructionLabel.text = "Verify your new passcode"
                        self.errorView.isHidden = true
                        self.leadingConstraint.constant = 0
                        UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0, options: .curveEaseOut, animations: {
                            self.view.layoutIfNeeded()
                            
                        }, completion: nil)
                    })
                    
                } else {
                    
                    if code == newPasscode {
                        
                        TMPasscodeLock.passcode = code
                        textField.resignFirstResponder()
                        delegate?.passcodeLockViewControllerDidFinish(state: state)
                        
                    } else {
                        
                        newPasscode = nil
                        
                        self.leadingConstraint.constant = self.view.frame.width
                        
                        UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0, options: .curveEaseOut, animations: {
                            
                            self.view.layoutIfNeeded()
                            
                        }, completion: { (finished) in
                            
                            self.leadingConstraint.constant = -self.view.frame.width
                            self.view.layoutIfNeeded()
                            self.instructionLabel.text = "Enter your new passcode"
                            self.showError(message: "Passcodes did not match")
                            self.leadingConstraint.constant = 0
                            UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0, options: .curveEaseOut, animations: {
                                self.view.layoutIfNeeded()
                                
                            }, completion: nil)
                        })
                        
                    }
                    
                }
            }

            break
        case .remove:
            
            if code == TMPasscodeLock.passcode {
                TMPasscodeLock.passcode = nil
                textField.resignFirstResponder()
                delegate?.passcodeLockViewControllerDidFinish(state: state)
            } else {
                showError(message: "Passcode Incorrect")
            }

            break
        }
    }
    
    func showError(message: String) {
        errorLabel.text = message
        errorView.isHidden = false
        
        clearPasscode()
    }

    func clearPasscode() {
        dot1.isHidden = true
        dot2.isHidden = true
        dot3.isHidden = true
        dot4.isHidden = true
        textField.text = nil
    }
}

extension TMPasscodeLockViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        switch newString.characters.count {
        case 0:
            dot1.isHidden = true
            break
        case 1:
            dot1.isHidden = false
            dot2.isHidden = true
            break
        case 2:
            dot2.isHidden = false
            dot3.isHidden = true
            break
        case 3:
            dot3.isHidden = false
            dot4.isHidden = true
            break
        case 4:
            dot4.isHidden = false
            break
        default:
            return false
        }
        
        textField.text = newString

        if newString.characters.count == 4 {
            checkPasscode(code: newString)
        }
        
        return false
    }
    
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
}
