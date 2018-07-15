//
//  SimpleDietTabBarController.swift
//  SimpleDieting
//
//  Created by Bill Weatherwax on 7/12/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit

class SimpleDietTabBarController: UITabBarController
{
    // MARK: - global model controller
    var modelController : ModelController!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
   
    
    func getModel()->ModelController {
        return modelController
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
