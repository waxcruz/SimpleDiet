//
//  LoadingPleaseWaitViewController.swift
//  HealthyWayAdmin
//
//  Created by Bill Weatherwax on 9/7/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit
import HealthyWayFramework


class LoadingPleaseWaitViewController: UIViewController {

    @IBOutlet weak var copyright: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        copyright.text = makeCopyright()
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
