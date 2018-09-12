//
//  HandoutsViewController.swift
// HealthyWay
//
//  Created by Bill Weatherwax on 8/11/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit
import HealthyWayFramework

class HandoutsViewController: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func linkToEducationalLibrary(_ sender: Any) {
        
        let dict : [String: Any?] = [:]
        if let url = URL(string: "https://thehealthyway.us/educational-library/") {
            UIApplication.shared.open(url, options: dict as Any as! [String : Any], completionHandler: nil)
        } else {
            NSLog("Can't open https://thehealthyway.us/educational-library/")
        }


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
