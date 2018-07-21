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
    //MARK - Firebase keys
    enum KeysForFirebase {
        //MARK: - Firebase NONSQL Segment Names
        static let TABLE_CONSUME = "Consume"
        static let TABLE_STATS = "Stats"
        static let TABLE_MEAL_CONTENTS = "MealContents"
        static let TABLE_SETTINGS = "Settings"
        //MARK: - Settings fields
        static let TARGET_DATE = "TARGET_DATE_KEY"
        static let TARGET_WEIGHT = "TARGET_WEIGHT_KEY"
        static let LIMIT_FAT = "LIMIT_FAT"
        static let LIMIT_FRUIT = "LIMIT_FRUIT"
        static let LIMIT_PROTEIN = "LIMIT_PROTEIN"
        static let LIMIT_STARCH = "LIMIT_STARCH"
        static let LIMIT_VEGGIES = "LIMIT_VEGGIES"
        //MARK: - Stats fields
        static let GLASSES_OF_WATER = "GLASSES_OF_WATER"
        static let MINUTES_EXERCISED = "MINUTES_EXERCISED"
        static let WEIGHED = "WEIGHED"
        //MARK: - Consume fields
        static let MEAL_DESCRIPTION = "MEAL_DATE"
        static let BREAKFAST_MEAL_KEY = "MEAL_DESCRIPTION"
        static let MORNING_SNACK_MEAL_KEY = "MORNING_SNACK_MEAL_KEY"
        static let LUNCH_MEAL_KEY = "LUNCH_MEAL_KEY"
        static let AFTERNOON_SNACK_MEAL_KEY = "AFTERNOON_SNACK_MEAL_KEY"
        static let DINNER_MEAL_KEY = "DINNER_MEAL_KEY"
        static let EVENING_SNACK_MEAL_KEY = "EVENING_SNACK_MEAL_KEY"
        //MARK: - MealContents fields
        static let MEAL_PROTEIN_QUANTITY = "MEAL_PROTEIN_QUANTITY"
        static let MEAL_FAT_QUANTITY = "MEAL_FAT_QUANTITY"
        static let MEAL_STARCH_QUANTITY = "MEAL_STARCH_QUANTITY"
        static let MEAL_FRUIT_QUANTITY = "MEAL_FRUIT_QUANTITY"
        static let MEAL_VEGGIES_QUANTITY = "MEAL_VEGGIES_QUANTITY"
        
    }
    var ref = DatabaseReference()
    var refHandle = DatabaseHandle()
    var settingsHandle  = DatabaseHandle()
    var consumeHandle = DatabaseHandle()
    var statsHandle = DatabaseHandle()
    var mealContentsHandle = DatabaseHandle()
    var settingsInFirebase : Dictionary? = [:]
    var firebaseDateKey : String = "YYYY-MM-DD"
    var statsInFirebase : Dictionary? = [:]
    var consumeInFirebase : Dictionary? = [:]
    var mealContentsInFirebase : Dictionary? = [:]
    
    // MARK: - structures
    var myGoal : Goal {
        get {
            return Goal()
        }
        
        set {
            NSLog("Test")
        }
    }
    // MARK: - methods
    
    func startModel(){
        ref = Database.database().reference()
        myGoal = Goal()
        var testGoal = myGoal
        testGoal.targetDate = Date().makeShortStringDate()
        NSLog(testGoal.targetDate)
    }
    
    func stopModel(){
        ref.removeObserver(withHandle: refHandle)
    }
    
    func breakConnectionToFirebase() {
        ref.removeObserver(withHandle: refHandle)
    }
    
    func makeConnectionToFirebase() {
        // Connect to Settings
        let settingsRef = ref.child("Settings")
        settingsHandle = settingsRef.observe(DataEventType.value, with: { (snapshot) in
            self.settingsInFirebase = snapshot.value as? [String : AnyObject] ?? [:]
        })

        let consumeRef = ref.child("Consume")
        consumeHandle = consumeRef.observe(DataEventType.value, with: { (snapshot) in
            self.consumeInFirebase = snapshot.value as? [String : AnyObject] ?? [:]
        })
        let statsRef = ref.child("Stats")
        statsHandle = statsRef.observe(DataEventType.value, with: { (snapshot) in
            self.statsInFirebase = snapshot.value as? [String : AnyObject] ?? [:]
//            for key in (self.statsInFirebase?.keys)! {
//                NSLog("key: \(key)")
//            }
//            for value in (self.statsInFirebase?.values)! {
//                NSLog("value: \(value)")
//                var dict = value as! Dictionary<String, Any>
//                let dictValue =  dict["WEIGHED"]
//            }
        })
        let mealContentsRef = ref.child("MealContents")
        mealContentsHandle = mealContentsRef.observe(DataEventType.value, with: { (snapshot) in
            self.mealContentsInFirebase = snapshot.value as? [String : AnyObject] ?? [:]
        })
    }

    
    func getStats(recordedOnDateKey date : String)-> Stats {
        // date must be of the form YYYY-MM-DD or no match will be found
        let statsForDate = Stats(
            recordForDate: date,
            glassesOfWaterConsumed: statsInFirebase![KeysForFirebase.GLASSES_OF_WATER] as! Int,
            weightOnDate: statsInFirebase![KeysForFirebase.WEIGHED] as! Double,
            minutesExercising: statsInFirebase![KeysForFirebase.MINUTES_EXERCISED] as! Int)
        return statsForDate
    }
    
    func getConsume(mealConsumedOnDateKey date: String) {
        // date must be of the form YYYY-MM-DD or no match will be found
        let consumeRef = self.ref.child("Consume")
        self.refHandle = consumeRef.observe(DataEventType.value, with: { (snapshot) in
            self.consumeInFirebase = snapshot.value as? [String : AnyObject] ?? [:]
        })
    }

    
    func getMealContents(mealContentsKey meal : String) {
        // meal key must be of the form YYYY-MM-DD-T or no match will be found
        let mealContentsRef = self.ref.child("MealContents")
        self.refHandle = mealContentsRef.observe(DataEventType.value, with: { (snapshot) in
            self.mealContentsInFirebase = snapshot.value as? [String : AnyObject] ?? [:]
        })
    }
    
    // MARK: - properties
    
    var targetDate : Date? {
        get {
            if let target_date_string = settingsInFirebase?[KeysForFirebase.TARGET_DATE] {
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
            if settingsInFirebase == nil {
                NSLog("settings doesn't exist set targetDate")
            } else {
                updateChildInFirebase(fireBaseTable: KeysForFirebase.TABLE_SETTINGS, fireBaseChildPath: KeysForFirebase.TARGET_DATE, value: target_date_string!)
                settingsInFirebase![KeysForFirebase.TARGET_DATE] = target_date_string
            }
         }
    }
    
    var targetWeight : Double? {
        get {
            if let target_weight = settingsInFirebase?[KeysForFirebase.TARGET_WEIGHT]  {
                return target_weight as? Double
            } else {
                return 0.0
            }
        }
        
        set {
             if settingsInFirebase == nil {
                NSLog("settings doesn't exist in set of targetWeight")
            } else {
                updateChildInFirebase(fireBaseTable: KeysForFirebase.TABLE_SETTINGS, fireBaseChildPath: KeysForFirebase.TARGET_WEIGHT, value: newValue!)
                settingsInFirebase![KeysForFirebase.TARGET_WEIGHT] = newValue
            }
        }
        
    }
    
    var limitsProtein : Int? {
        get {
            if let protein = settingsInFirebase?[KeysForFirebase.LIMIT_PROTEIN] {
                return protein as? Int
            } else {
                return 0
            }
        }
        
        set {
            if settingsInFirebase == nil {
                NSLog("settings doesn't exist in set limitsProtein")
            } else {
                updateChildInFirebase(fireBaseTable: KeysForFirebase.TABLE_SETTINGS, fireBaseChildPath: KeysForFirebase.LIMIT_PROTEIN, value: newValue!)
                settingsInFirebase?[KeysForFirebase.LIMIT_PROTEIN] = newValue
            }
        }
    }
 
    var limitsFat : Int? {
        get {
            if let fat = settingsInFirebase?[KeysForFirebase.LIMIT_FAT] {
                return fat as? Int
            } else {
                return 0
            }
        }
        
        set {
            if settingsInFirebase == nil {
                NSLog("settings doesn't exist in set limitsFat")
            } else {
                updateChildInFirebase(fireBaseTable: KeysForFirebase.TABLE_SETTINGS, fireBaseChildPath: KeysForFirebase.LIMIT_FAT, value: newValue!)
                settingsInFirebase?[KeysForFirebase.LIMIT_FAT] = newValue
            }
        }
    }
    

    var limitsFruit : Int? {
        get {
            if let fruit = settingsInFirebase?[KeysForFirebase.LIMIT_FRUIT] {
                return fruit as? Int
            } else {
                return 0
            }
        }
    
        set {
            if settingsInFirebase == nil {
                NSLog("settings doesn't exist in set limitsFruit")
            } else {
                updateChildInFirebase(fireBaseTable: "Settings", fireBaseChildPath: KeysForFirebase.LIMIT_FRUIT, value: newValue!)
                settingsInFirebase?[KeysForFirebase.LIMIT_FRUIT] = newValue
            }
        }
    }
    
    var limitsStarch : Int? {
        get {
            if let starch = settingsInFirebase?[KeysForFirebase.LIMIT_STARCH] {
                return starch as? Int
            } else {
                return 0
            }
        }
        
        set {
            if settingsInFirebase == nil {
                NSLog("settings doesn't exist in set limitsStarch")
            } else {
                updateChildInFirebase(fireBaseTable: "Settings", fireBaseChildPath: KeysForFirebase.LIMIT_STARCH, value: newValue!)
                settingsInFirebase?[KeysForFirebase.LIMIT_STARCH] = newValue
            }
        }
    }
    
    var limitsVeggies : Int? {
        get {
            if let veggies = settingsInFirebase?[KeysForFirebase.LIMIT_VEGGIES] {
                return veggies as? Int
            } else {
                return 0
            }
        }
        
        set {
            if settingsInFirebase == nil {
                NSLog("settings doesn't exist in set limitsVeggies")
            } else {
                settingsInFirebase?[KeysForFirebase.LIMIT_VEGGIES] = newValue
            }
        }
    }
    
  
    var statsWaterConsumed : Int? {
        get {
            if let water = statsInFirebase?[KeysForFirebase.GLASSES_OF_WATER] {
                return water as? Int
            } else {
                return 0
            }
        }
        
        set {
            if settingsInFirebase == nil {
                NSLog("settings doesn't exist in set statsWaterConsumed")
            } else {
                updateChildOfRecordInFirebase(fireBaseTable: KeysForFirebase.TABLE_STATS, fireBaseRecordID: firebaseDateKey, fireBaseChildPath: KeysForFirebase.GLASSES_OF_WATER, value: newValue)
                statsInFirebase?[KeysForFirebase.GLASSES_OF_WATER] = newValue
            }
        }
    }

    var statsWeight : Int? {
        get {
            if let weight = settingsInFirebase?[KeysForFirebase.WEIGHED] {
                return weight as? Int
            } else {
                return 0
            }
        }
        
        set {
            if settingsInFirebase == nil {
                NSLog("settings doesn't exist in set statsWeight")
            } else {
                updateChildOfRecordInFirebase(fireBaseTable: KeysForFirebase.TABLE_STATS, fireBaseRecordID: firebaseDateKey, fireBaseChildPath: KeysForFirebase.WEIGHED, value: newValue)
                statsInFirebase?[KeysForFirebase.WEIGHED] = newValue
            }
        }
    }

    var statsExercise : Int? {
        get {
            if let exercise = settingsInFirebase?[KeysForFirebase.MINUTES_EXERCISED] {
                return exercise as? Int
            } else {
                return 0
            }
        }
        
        set {
            if settingsInFirebase == nil {
                NSLog("settings doesn't exist in set statsExercise")
            } else {
                updateChildOfRecordInFirebase(fireBaseTable: KeysForFirebase.TABLE_STATS, fireBaseRecordID: firebaseDateKey, fireBaseChildPath: KeysForFirebase.WEIGHED, value: newValue)
                statsInFirebase?[KeysForFirebase.WEIGHED] = newValue
            }
        }
    }

    
     // MARK - Convenience methods for displaying properties in views
    
    func targetWeigthString() -> String {
        if targetWeight != nil {
            return String(format:"%.1f", targetWeight!)
        }
            return "0.0"
    }

    func targetDateString() -> String {
        return (targetDate?.makeShortStringDate())!
    }
    
    // MARK - Helper methods for Firebase
    
    func updateChildInFirebase(fireBaseTable table : String, fireBaseChildPath path : String, value : Any) {
        let fullFirebasePath : String? = table + "/" + path
        if fullFirebasePath != nil {
            ref.child(fullFirebasePath!).setValue(value)
        } else {
            NSLog("error in updateChildInFirebase")
        }
    }
    
    func updateChildOfRecordInFirebase(fireBaseTable table : String, fireBaseRecordID recordID : String, fireBaseChildPath path : String, value : Any) {
        let fullFirebasePath : String? = table + "/" + recordID + "/" + path
        if fullFirebasePath != nil {
            ref.child(fullFirebasePath!).setValue(value)
        } else {
            NSLog("error in updateChildOfRecordInFirebase")
        }
        
    }
    
    
    
    
}





