//
//  TransitionViewController.swift
//  SimpleDieting
//
//  Created by Bill Weatherwax on 7/20/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//
// Dummy View Controller used to overcome the momentary black screen before TabBarViewController displays

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var copyright: UILabel!
    
    
    // MARK: - global model controller
    var modelController : ModelController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        copyright.text = makeCopyright()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInToApp(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueDummy", sender: self)
        }
   }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SimpleDietTabBarController {
            vc.modelController = modelController
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
