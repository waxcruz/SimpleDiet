//
//  ForgottenPasswordViewController.swift
//  LearnFirebaseAuthenticationAndAuthorization
//
//  Created by Bill Weatherwax on 8/21/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import HealthyWayFramework

class ForgottenPasswordViewController: UIViewController {
    // MARK: - global model controller
    var modelController : ModelController!
    
   // MARK - properties
    var emailEntered : String?
    var hwClientPasswordEntered : String?
    var newPasswordEntered : String?
    var confirmPasswordEntered : String?
    
    // MARK - Sign-in fields
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var copyright: UILabel!
    
    // MARK - Firebase properties

    override func viewDidLoad() {
        super.viewDidLoad()
        copyright.text = makeCopyright()
         email.addTarget(self, action: #selector(ForgottenPasswordViewController.textFieldDidEnd(_:)), for: UIControlEvents.editingDidEndOnExit)
        message.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
    }

    @objc func textFieldDidEnd(_ textField: UITextField){
        textField.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        message.text = Constants.NOTICE_RESET_PASSWORD
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(_ sender: Any) {
        email.resignFirstResponder()
        message.text = ""
        modelController.signoutUser(errorHandler: errorMessage)
        emailEntered = email.text
        // temporary check until Chel decides how to reset passwords
        modelController.passwordReset(clientEmail : emailEntered!, errorHandler : errorMessage, handler : sendEmailInstructions)
    }

    func errorMessage(error : String) {
        message.text = error
    }

    func sendEmailInstructions() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
