//
//  SettingsViewController.swift
//  TMPasscodeLock
//
//  Created by Travis Morgan on 1/16/17.
//  Copyright © 2017 Travis Morgan. All rights reserved.
//

import UIKit
import TMPasscodeLock

class SettingsViewController: UITableViewController, TMPasscodeLockControllerDelegate {
    
    @IBOutlet var passcodeCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        passcodeCell.detailTextLabel?.text = TMPasscodeLockController.isPasscodeSet ? "On" : "Off"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if TMPasscodeLockController.isPasscodeSet {
            performSegue(withIdentifier: "Passcode", sender: nil)
        } else {
            let passcodeLockController = TMPasscodeLockController(style: .basic, state: .set)
            passcodeLockController.delegate = self
            passcodeLockController.presentIn(viewController: self, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func passcodeLockControllerDidCancel(passcodeLockController: TMPasscodeLockController) {
        
    }
    
    func passcodeLockController(passcodeLockController: TMPasscodeLockController, didFinishFor state: TMPasscodeLockState) {
        passcodeCell.detailTextLabel?.text = TMPasscodeLockController.isPasscodeSet ? "On" : "Off"
    }
}
