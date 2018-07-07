//
//  ModelController.swift
//  SimpleDieting
//
//  Created by Bill Weatherwax on 7/5/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import Foundation
import UIKit



class ModelController
{
    enum KeysForUserDefaults {
        static let TARGET_DATE = "TARGET_DATE_KEY"
        static let TARGET_WEIGHT = "TARGET_WEIGHT_KEY"
    }
    
    
    var date : Date? {
        get {
            let defaults = UserDefaults.standard
            if let storedDate = defaults.object(forKey: KeysForUserDefaults.TARGET_DATE) as? Date {
                return storedDate
            } else {
                let date = Date()
                defaults.set(date, forKey: KeysForUserDefaults.TARGET_DATE)
                return date
            }
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: KeysForUserDefaults.TARGET_DATE)
        }
    }
    
    var weight : Double? {
        get {
            let defaults = UserDefaults.standard
            if let storedWeight = defaults.object(forKey: KeysForUserDefaults.TARGET_WEIGHT) as? Double {
                return storedWeight
            } else {
                let newWeight = 0.0
                defaults.set(newWeight, forKey: KeysForUserDefaults.TARGET_WEIGHT)
                return newWeight
            }
            
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: KeysForUserDefaults.TARGET_WEIGHT)
        }
        
    }
    
    func weigthString() -> String {
        if weight != nil {
            return String(format:"%.1f", weight!)
        }
            return "0.0"
    }

    func dateString() -> String {
        let dateFormat = DateFormatter()
        if date != nil {
            dateFormat.dateStyle = DateFormatter.Style.short
            dateFormat.timeStyle = DateFormatter.Style.none
            return dateFormat.string(from: date!)
        } else {
            return dateFormat.string(from: Date())
        }
    }
    
    
    
}
