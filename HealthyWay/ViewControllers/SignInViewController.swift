//
//  ViewController.swift
//  LearnFirebaseAuthenticationAndAuthorization
//
//  Created by Bill Weatherwax on 8/19/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit
import Firebase
import HealthyWayFramework

class SignInViewController: UIViewController {
    // MARK: - global model controller
    var modelController : ModelController!
    // MARK: - view window
    var window: UIWindow?
    // MARK - properties
    var emailEntered : String?
    var passwordEntered : String?

    
    // MARK - Sign-in fields
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var copyright: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // AppDelegate post modelController in this view controller
        copyright.text = makeCopyright()
        email.addTarget(self, action: #selector(SignInViewController.textFieldDidEnd(_:)), for: UIControlEvents.editingDidEndOnExit)
        password.addTarget(self, action: #selector(SignInViewController.textFieldDidEnd(_:)), for: UIControlEvents.editingDidEndOnExit)
        message.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        email.text = ""
        password.text = ""
    }

    @objc func textFieldDidEnd(_ textField: UITextField){
        textField.resignFirstResponder()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let uid = Auth.auth().currentUser?.uid {
            modelController.signedinUID = uid
            modelController.signedinEmail = Auth.auth().currentUser?.email
//            // Set the window to the dimensions of the device
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//
//            // Grab a reference to whichever storyboard you have the ViewController within
//            let storyboard = UIStoryboard(name: Constants.MAIN, bundle: nil)
//
//            // Grab a reference to the ViewController you want to show 1st.
//            var initialViewController = UIViewController()
//
//            initialViewController = storyboard.instantiateViewController(withIdentifier: Constants.HEALTHY_WAY_TABBAR_CONTOLLER_ID) // HealthyWayTabBarControllerID
//            // Set that ViewController as the rootViewController
//            self.window?.rootViewController = initialViewController
//
//            // Make sure correct view controller loaded
//            if let vc = window?.rootViewController as? HealthyWayTabBarController { // start with Signin
//                vc.modelController = modelController
//            } else {
//                print("Problem in AppDelegate.swift")
//            }
//            // Sets our window up in front
//            self.window?.makeKeyAndVisible()
            getUserData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK - actions
    @IBAction func login(_ sender: Any) {
        email.resignFirstResponder()
        password.resignFirstResponder()
        modelController.signoutUser(errorHandler: authErrorDisplay)
        emailEntered = email.text
        passwordEntered = password.text
        modelController.loginUser(email: emailEntered!, password: passwordEntered!, errorHandler: authErrorDisplay, handler: getUserData)
    }
    
    func authErrorDisplay(errorMessage : String) {
        message.text = errorMessage
    }
    

    @IBAction func unwindToSignInViewController(segue:UIStoryboardSegue) {
    }

    
    // MARK - process data
    func getUserData() {
            self.performSegue(withIdentifier: Constants.SEGUE_FROM_SIGNIN_TO_TAB_CONTROLLER, sender: nil)
    }
    
    
    
 
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.

        let vc = segue.destination
        if vc .isKind(of: ForgottenPasswordViewController.self) {
            (vc as! ForgottenPasswordViewController).modelController = modelController
        } else {
            if vc .isKind(of: CreateNewAccountViewController.self) {
                (vc as! CreateNewAccountViewController).modelController = modelController
            } else {
                if vc .isKind(of: HealthyWayTabBarController.self) {
                    (vc as! HealthyWayTabBarController).modelController = modelController
                }
            }
        }

     }


    
    
}

