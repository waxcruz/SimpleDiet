//
//  ModelController.swift
//  SimpleDieting
//
//  Created by Bill Weatherwax on 7/5/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class ModelController
{
    enum KeysForUserDefaults {
        static let TARGET_DATE = "TARGET_DATE_KEY"
        static let TARGET_WEIGHT = "TARGET_WEIGHT_KEY"
        static let LIMIT_FAT = "LIMIT_FAT"
        static let LIMIT_FRUIT = "LIMIT_FRUIT"
        static let LIMIT_PROTEIN = "LIMIT_PROTEIN"
        static let LIMIT_STARCH = "LIMIT_STARCH"
        static let LIMIT_VEGGIES = "LIMIT_VEGGIES"

    }
    var ref: DatabaseReference!
    var refHandle : DatabaseHandle!
    var settings : Dictionary? = [:]
    func startModel(){
        ref = Database.database().reference()
    }
    
    func stopModel(){
        ref.removeObserver(withHandle: refHandle)
    }
    
    
    func getSettings(){
        let settingsRef = self.ref.child("Settings")
        self.refHandle = settingsRef.observe(DataEventType.value, with: { (snapshot) in
            self.settings = snapshot.value as? [String : AnyObject] ?? [:]
        })
    }
    
    var date : Date? {
        get {
            if let target_date_string = settings?[KeysForUserDefaults.TARGET_DATE] {
                var myDate = Date()
                myDate.makeDateFromString(dateAsString: target_date_string as! String)
                if myDate.description == Date(timeIntervalSince1970: 0).description {
                    NSLog("date Bad")
                    return Date()
                } else {
                    return myDate
                }
            } else {
                let dateToday = Date()
                return dateToday
            }
        }
        
        set {
            let target_date_string = newValue?.makeShortStringDate()
            ref.child("Settings/\(KeysForUserDefaults.TARGET_DATE)").setValue(target_date_string)
            if settings == nil {
                NSLog("settings doesn't exist because of a timing error")
            } else {
                settings![KeysForUserDefaults.TARGET_DATE] = target_date_string
            }
         }
    }
    
    var weight : Double? {
        get {
            if let target_weight = settings?[KeysForUserDefaults.TARGET_WEIGHT]  {
                return target_weight as? Double
            } else {
                return 0.0
            }
        }
        
        set {

            ref.child("Settings/\(KeysForUserDefaults.TARGET_WEIGHT)").setValue(newValue)
            if settings == nil {
                NSLog("settings doesn't exist because of a timing error")
            } else {
                settings![KeysForUserDefaults.TARGET_WEIGHT] = newValue
            }
        }
        
    }
    
    func weigthString() -> String {
        if weight != nil {
            return String(format:"%.1f", weight!)
        }
            return "0.0"
    }

    func dateString() -> String {
        return (date?.makeShortStringDate())!
//        let dateFormat = DateFormatter()
//        if date != nil {
//            dateFormat.dateStyle = DateFormatter.Style.short
//            dateFormat.timeStyle = DateFormatter.Style.none
//            return dateFormat.string(from: date!)
//        } else {
//            return dateFormat.string(from: Date())
//        }
    }
    
    
    
}
