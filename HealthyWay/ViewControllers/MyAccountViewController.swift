//
//  MyAccountViewController.swift
//  Healthy Way
//
//  Created by Bill Weatherwax on 9/10/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit
import FirebaseAuth
import HealthyWayFramework


class MyAccountViewController: UIViewController {
    // MARK: - global model controller
    var modelController : ModelController!
    
    @IBOutlet weak var copyright: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        copyright.text = makeCopyright()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signout(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch {
                print("SettngsViewController, Sign out failed")
            }
        }
        modelController.currentUID = nil
        performSegue(withIdentifier: Constants.UNWIND_TO_SIGNIN_FROM_MY_ACCOUNT, sender: self)
    }
    
    
    
    
    
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destination
        if vc .isKind(of: ChangePasswordViewController.self) {
            (vc as! ChangePasswordViewController).modelController = modelController
        } else {
            if vc .isKind(of: SignInViewController.self) {
                if (vc as! SignInViewController).modelController == nil {
                    print("Segue to improperly prepared view controller, SignInViewController")
                } else {
                    print("Unwinding to SignInViewController")
                }
            }
            print("Unknown segue (", vc.debugDescription, ") in ClientViewController")
        }
    }
    

}
