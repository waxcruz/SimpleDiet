//
//  SocialMediaViewController.swift
// HealthyWay
//
//  Created by Bill Weatherwax on 8/11/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit
import HealthyWayFramework

class SocialMediaViewController: UIViewController {

    @IBOutlet weak var copyright: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        copyright.text = makeCopyright()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func linkToEducationalLibarary(_ sender: Any) {
        
        let dict : [String: Any?] = [:]
        if let url = URL(string: "https://thehealthyway.us/") { // educational-library/
            UIApplication.shared.open(url, options: dict as Any as! [String : Any], completionHandler: nil)
        } else {
            NSLog("Can't open https://thehealthyway.us/") // educational-library/
        }
        
   }
    
    
    
    @IBAction func facebook(_ sender: Any) {
        let dict : [String: Any?] = [:]
        if let url = URL(string: "https://www.facebook.com/HealthyWaySantaCruz/") {
            UIApplication.shared.open(url, options: dict as Any as! [String : Any], completionHandler: nil)
        } else {
            NSLog("Can't open https://www.facebook.com/HealthyWaySantaCruz/")
        }

        
    }
 
    
    @IBAction func instagram(_ sender: Any) {
        let dict : [String: Any?] = [:]
        if let url = URL(string: "https://www.instagram.com/healthywaysantacruz//") {
            UIApplication.shared.open(url, options: dict as Any as! [String : Any], completionHandler: nil)
        } else {
            NSLog("Can't open https://www.instagram.com/healthywaysc/")
        }
    }
    
    
    @IBAction func youtube(_ sender: Any) {
        let dict : [String: Any?] = [:]
        if let url = URL(string: "https://www.youtube.com/channel/UCa9DlxctvfyFrFcoaLB0tzA") {
            UIApplication.shared.open(url, options: dict as Any as! [String : Any], completionHandler: nil)
        } else {
            NSLog("Can't open https://www.youtube.com/channel/UCa9DlxctvfyFrFcoaLB0tzA")
        }
   }
    
    
    
    @IBAction func pinterest(_ sender: Any) {
        let dict : [String: Any?] = [:]
        if let url = URL(string: "https://www.pinterest.com/thhealthywaysc/?autologin=true") {
            UIApplication.shared.open(url, options: dict as Any as! [String : Any], completionHandler: nil)
        } else {
            NSLog("Can't open https://www.pinterest.com/thhealthywaysc/?autologin=true")
        }
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

