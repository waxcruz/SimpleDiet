//
//  ChangePasswordViewController.swift
//  LearnFirebaseAuthenticationAndAuthorization
//
//  Created by Bill Weatherwax on 8/21/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit
import HealthyWayFramework

class ChangePasswordViewController: UIViewController {
    // MARK: - global model controller
    var modelController : ModelController!
    
    @IBOutlet weak var copyright: UILabel!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var message: UITextView!
    // MARK - properties
    var oldPasswordEntered : String?
    var newPasswordEntered : String?
    var confirmPasswordEntered : String?
    var staffEmail : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        copyright.text = makeCopyright()
        oldPassword.addTarget(self, action: #selector(ChangePasswordViewController.textFieldDidEnd(_:)), for: UIControlEvents.editingDidEndOnExit)
        newPassword.addTarget(self, action: #selector(ChangePasswordViewController.textFieldDidEnd(_:)), for: UIControlEvents.editingDidEndOnExit)
        confirmPassword.addTarget(self, action: #selector(ChangePasswordViewController.textFieldDidEnd(_:)), for: UIControlEvents.editingDidEndOnExit)
        message.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func textFieldDidEnd(_ textField: UITextField){
        textField.resignFirstResponder()
    }
    

    @IBAction func submit(_ sender: Any) {
        oldPassword.resignFirstResponder()
        newPassword.resignFirstResponder()
        confirmPassword.resignFirstResponder()
        message.text = ""
        let authenticatedUID = modelController.signedinUID
        oldPasswordEntered = oldPassword.text
        newPasswordEntered = newPassword.text
        confirmPasswordEntered = confirmPassword.text
        if newPasswordEntered != confirmPasswordEntered {
            message.text = "Passwords mismatched. Try again"
            return
        }
        if authenticatedUID != nil {
            // force sign out of current user to prevent fraudulent changes
            staffEmail = modelController.signedinEmail // retain email 
            modelController.signoutUser(errorHandler: authErrorMessage, handler: loginStaff)
        } else {
            message.text = "You must be signed in"
        }
    }

    // Mark - helper functions
    
    func loginStaff() {
        // verify user's identity
        oldPasswordEntered = oldPassword.text
        modelController.loginUser(email: staffEmail!, password: oldPasswordEntered!, errorHandler: authErrorMessage, handler: updateStaffPassword)
    }
    
    func updateStaffPassword() {
        // make the password change
        newPasswordEntered = newPassword.text
        modelController.updatePassword(newPassword: newPasswordEntered!, errorHandler: authErrorMessage, handler: changedPasswordSuccessfully)
    }
    
    
    
    func authErrorMessage(message : String) {
        self.message.text = message
    }
    
    func changedPasswordSuccessfully() {
        self.message.text = "Password change succeeded"
        performSegue(withIdentifier: Constants.UNWIND_TO_SETTINGS_FROM_CHANGE_PASSWORD, sender: self)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
