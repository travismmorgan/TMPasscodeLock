//
//  PasscodeViewController.swift
//  TMPasscodeLock
//
//  Created by Travis Morgan on 1/16/17.
//  Copyright © 2017 Travis Morgan. All rights reserved.
//

import UIKit
import TMPasscodeLock

class PasscodeViewController: UITableViewController, TMPasscodeLockControllerDelegate {
    
    @IBOutlet var changePasscodeCell: UITableViewCell!
    @IBOutlet var removePasscodeCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath) == changePasscodeCell {
            
            let passcodeLockController = TMPasscodeLockController(style: .basic, state: .change)
            passcodeLockController.delegate = self
            passcodeLockController.presentIn(viewController: self, animated: true)
            
        } else if tableView.cellForRow(at: indexPath) == removePasscodeCell {
            
            let passcodeLockController = TMPasscodeLockController(style: .basic, state: .remove)
            passcodeLockController.delegate = self
            passcodeLockController.presentIn(viewController: self, animated: true)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func passcodeLockControllerDidCancel(passcodeLockController: TMPasscodeLockController) {
        
    }
    
    func passcodeLockController(passcodeLockController: TMPasscodeLockController, didFinishFor state: TMPasscodeLockState) {
        if state == .remove {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                _ = self.navigationController?.popViewController(animated: true)
            })

        }
    }
}
