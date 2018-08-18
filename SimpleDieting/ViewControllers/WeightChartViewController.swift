//
//  WeightChartViewController.swift
//  SimpleDieting
//
//  Created by Bill Weatherwax on 7/21/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit

class WeightChartViewController: UIViewController {

    @IBOutlet weak var copyright: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        copyright.text = makeCopyright()
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
