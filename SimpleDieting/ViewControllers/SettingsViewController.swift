//
//  MealsViewController.swift
//  SimpleDieting
//
//  Created by Bill Weatherwax on 7/14/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - global model controller
    var modelController : ModelController!

    override func viewDidLoad() {
        super.viewDidLoad()
        modelController = (self.parent as! SimpleDietTabBarController).getModel()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
