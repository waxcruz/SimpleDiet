//
//  ModelController.swift
//  SimpleDieting
//
//  Created by Bill Weatherwax on 7/5/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import Foundation
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
    
    var targetDate : Date? {
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
                NSLog("settings doesn't exist set targetDate")
            } else {
                settings![KeysForUserDefaults.TARGET_DATE] = target_date_string
            }
         }
    }
    
    var targetWeight : Double? {
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
                NSLog("settings doesn't exist in set of targetWeight")
            } else {
                settings![KeysForUserDefaults.TARGET_WEIGHT] = newValue
            }
        }
        
    }
    
    func targetWeigthString() -> String {
        if targetWeight != nil {
            return String(format:"%.1f", targetWeight!)
        }
            return "0.0"
    }

    func targetDateString() -> String {
        return (targetDate?.makeShortStringDate())!
    }
    
    var dailyLimits : Limits {
        get {
            var limits = Limits()
            if let protein = settings?[KeysForUserDefaults.LIMIT_PROTEIN] {
                limits.protein = protein as! Int
            } else {
                limits.protein = 0
            }
            if let fat = settings?[KeysForUserDefaults.LIMIT_FAT] {
                limits.fat = fat as! Int
            } else {
                limits.fat = 0
            }
            if let fruit = settings?[KeysForUserDefaults.LIMIT_FRUIT] {
                limits.fruit = fruit as! Int
            } else {
                limits.fruit = 0
            }
            if let starch = settings?[KeysForUserDefaults.LIMIT_STARCH] {
                limits.starch = starch as! Int
            } else {
                limits.starch = 0
            }
            if let veggies = settings?[KeysForUserDefaults.LIMIT_VEGGIES] {
                limits.veggies = veggies as! Int
            } else {
                limits.veggies = 0
            }
            return limits
        }
        
        set {
            ref.child("Settings/\(KeysForUserDefaults.TARGET_WEIGHT)").setValue(newValue)
            if settings == nil {
                NSLog("settings doesn't exist in set dailyLimits")
            } else {
                settings?[KeysForUserDefaults.LIMIT_PROTEIN] = newValue.protein
                settings?[KeysForUserDefaults.LIMIT_FAT] = newValue.fat
                settings?[KeysForUserDefaults.LIMIT_STARCH] = newValue.starch
                settings?[KeysForUserDefaults.LIMIT_FRUIT] = newValue.fruit
                settings?[KeysForUserDefaults.LIMIT_VEGGIES] = newValue.veggies
                ref.child("Settings/\(KeysForUserDefaults.LIMIT_PROTEIN)").setValue(newValue.protein)
                ref.child("Settings/\(KeysForUserDefaults.LIMIT_FAT)").setValue(newValue.fat)
                ref.child("Settings/\(KeysForUserDefaults.LIMIT_FRUIT)").setValue(newValue.fruit)
                ref.child("Settings/\(KeysForUserDefaults.LIMIT_STARCH)").setValue(newValue.starch)
                ref.child("Settings/\(KeysForUserDefaults.LIMIT_VEGGIES)").setValue(newValue.veggies)
            
            }

        }
    }
    
    
}
