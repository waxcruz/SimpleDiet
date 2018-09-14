//
//  CreateNewAccountViewController.swift
//  LearnFirebaseAuthenticationAndAuthorization
//
//  Created by Bill Weatherwax on 8/21/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import HealthyWayFramework


class CreateNewAccountViewController: UIViewController {
    // MARK: - global model controller
    var modelController : ModelController!
    
    // MARK - Sign-in fields
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var copyright: UILabel!
    
    
    
    // MARK - properties
    var emailEntered : String?
    var passwordEntered : String?
    var confirmPasswordEntered : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        copyright.text = makeCopyright()
        email.addTarget(self, action: #selector(CreateNewAccountViewController.textFieldDidEnd(_:)), for: UIControlEvents.editingDidEndOnExit)
        password.addTarget(self, action: #selector(CreateNewAccountViewController.textFieldDidEnd(_:)), for: UIControlEvents.editingDidEndOnExit)
        confirmPassword.addTarget(self, action: #selector(CreateNewAccountViewController.textFieldDidEnd(_:)), for: UIControlEvents.editingDidEndOnExit)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signIn(_ sender: Any) {
        email.resignFirstResponder()
        password.resignFirstResponder()
        confirmPassword.resignFirstResponder()
        message.text = ""
        modelController.signoutUser(errorHandler: authErrorDisplay)
        emailEntered = email.text
        passwordEntered = password.text
        confirmPasswordEntered = confirmPassword.text
        if passwordEntered != confirmPasswordEntered {
            message.text = "Passwords mismatched. Try again"
            return
        }
        modelController.createAuthUserNode(userEmail: emailEntered!, userPassword: passwordEntered!, errorHandler: authErrorDisplay, handler : creationOfClientSucceed)
}
        // MARK - handlers


    func creationOfClientSucceed() {
        // authentication complete, add client to Users node
        message.text = "Client account created"
        createClientInUsersNode()
        
    }


    func authErrorDisplay(errorMessage : String) {
        message.text = errorMessage
    }
    
    
    func databaseErrorDisplay(errorMessage : String) {
        message.text = errorMessage
    }
    
    func createClientInUsersNode() {
        modelController.createUserInUsersNode(userUID: modelController.signedinUID!, userEmail: emailEntered!, errorHandler: databaseErrorDisplay, handler: createClientInEmailsNode)
    }
    
    func createClientInEmailsNode() {
        message.text = "Client identity created"
        modelController.createEmailInEmailsNode(userUID: modelController.signedinUID!, userEmail: emailEntered!, errorHandling: databaseErrorDisplay, handler: completedClientCreationInDatabase)
    }
    
    func completedClientCreationInDatabase() {
        message.text = "Client email created"
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

*/
}
