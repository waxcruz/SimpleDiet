//
//  ModelController.swift
// HealthyWay
//
//  Created by Bill Weatherwax on 7/5/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import Foundation
import Firebase

class ModelController
{
    //MARK - Firebase
        // Reference and handles
    var ref = DatabaseReference()
    var refHandle = DatabaseHandle()
    var settingsHandle  = DatabaseHandle()
    var journalHandle = DatabaseHandle()
    var mealContentsHandle = DatabaseHandle()
        // Keys and content
    var firebaseDateKey : String = "YYYY-MM-DD"
    var settingsInFirebase : Dictionary? = [:]
    var journalInFirebase : Dictionary? = [:]
    var mealContentsInFirebase : Dictionary? = [:]

    
    // MARK: - methods
    
    func startModel(){
        ref = Database.database().reference()
    }
    
    func stopModel(){
        ref.removeObserver(withHandle: refHandle)
    }
    
    func breakConnectionToFirebase(typeOfHandle handle : FirebaseHandleIdentifiers) {
        var closeHandle = DatabaseHandle()
        switch (handle) {
        case FirebaseHandleIdentifiers.settings:
            closeHandle = settingsHandle
        case FirebaseHandleIdentifiers.journal:
            closeHandle = journalHandle
        case FirebaseHandleIdentifiers.mealContents:
            closeHandle = mealContentsHandle
        }
        ref.removeObserver(withHandle: closeHandle)
    }
    
    func makeConnectionToFirebase() {
        // Connect to Settings
        let settingsRef = ref.child(KeysForFirebase.TABLE_SETTINGS)
        settingsHandle = settingsRef.observe(DataEventType.value, with: { (snapshot) in
            self.settingsInFirebase = snapshot.value as? [String : AnyObject] ?? [:]
        })

        let journalRef = ref.child(KeysForFirebase.TABLE_JOURNAL)
        journalHandle = journalRef.observe(DataEventType.value, with: { (snapshot) in
            self.journalInFirebase = snapshot.value as? [String : AnyObject] ?? [:]
//            for key in (self.journalInFirebase?.keys)! {
//                NSLog("key: \(key)")
//            }
//            for value in (self.journalInFirebase?.values)! {
//                NSLog("value: \(value)")
//                var dict = value as! Dictionary<String, Any>
//                let dictValue =  dict["WEIGHED"]
//            }
        })
        let mealContentsRef = ref.child(KeysForFirebase.TABLE_MEAL_CONTENTS)
        mealContentsHandle = mealContentsRef.observe(DataEventType.value, with: { (snapshot) in
            self.mealContentsInFirebase = snapshot.value as? [String : AnyObject] ?? [:]
        })
    }
    func getJournal(journalOnDateKey date: String) {
        // date must be of the form YYYY-MM-DD or no match will be found
        let consumeRef = self.ref.child(KeysForFirebase.TABLE_JOURNAL)
        self.refHandle = consumeRef.observe(DataEventType.value, with: { (snapshot) in
            self.journalInFirebase = snapshot.value as? [String : AnyObject] ?? [:]
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
    
//    var targetDate : Date? {
//        get {
//            if let target_date_string = settingsInFirebase?[KeysForFirebase.TARGET_DATE] {
//                let myDate = makeDateFromString(dateAsString: target_date_string as! String)
//                if myDate.description == Date(timeIntervalSince1970: 0).description {
//                    NSLog("date Bad")
//                    return Date()
//                } else {
//                    return myDate
//                }
//            } else {
//                let dateToday = Date()
//                return dateToday
//            }
//        }
//
//        set {
//            let target_date_string = newValue?.makeShortStringDate()
//            if settingsInFirebase == nil {
//                NSLog("settings doesn't exist set targetDate")
//            } else {
//                updateChildInFirebase(fireBaseTable: KeysForFirebase.TABLE_SETTINGS, fireBaseChildPath: KeysForFirebase.TARGET_DATE, value: target_date_string!)
//                settingsInFirebase![KeysForFirebase.TARGET_DATE] = target_date_string
//            }
//         }
//    }
//
//    var targetWeight : Double? {
//        get {
//            if let target_weight = settingsInFirebase?[KeysForFirebase.TARGET_WEIGHT]  {
//                return target_weight as? Double
//            } else {
//                return 0.0
//            }
//        }
//
//        set {
//             if settingsInFirebase == nil {
//                NSLog("settings doesn't exist in set of targetWeight")
//            } else {
//                updateChildInFirebase(fireBaseTable: KeysForFirebase.TABLE_SETTINGS, fireBaseChildPath: KeysForFirebase.TARGET_WEIGHT, value: newValue!)
//                settingsInFirebase![KeysForFirebase.TARGET_WEIGHT] = newValue
//            }
//        }
//
//    }
//
    var limitsProteinLow : Double? {
        get {
            if let protein = settingsInFirebase?[KeysForFirebase.LIMIT_PROTEIN_LOW] {
                return protein as? Double
            } else {
                return 0.0
            }
        }
        
        set {
            if settingsInFirebase == nil {
                NSLog("settings doesn't exist in set limitsProtein")
            } else {
                updateChildInFirebase(fireBaseTable: KeysForFirebase.TABLE_SETTINGS, fireBaseChildPath: KeysForFirebase.LIMIT_PROTEIN_LOW, value: newValue!)
                settingsInFirebase?[KeysForFirebase.LIMIT_PROTEIN_LOW] = newValue
            }
        }
    }
 
    var limitsProteinHigh : Double? {
        get {
            if let protein = settingsInFirebase?[KeysForFirebase.LIMIT_PROTEIN_HIGH] {
                return protein as? Double
            } else {
                return 0.0
            }
        }
        
        set {
            if settingsInFirebase == nil {
                NSLog("settings doesn't exist in set limitsProtein")
            } else {
                updateChildInFirebase(fireBaseTable: KeysForFirebase.TABLE_SETTINGS, fireBaseChildPath: KeysForFirebase.LIMIT_PROTEIN_HIGH, value: newValue!)
                settingsInFirebase?[KeysForFirebase.LIMIT_PROTEIN_HIGH] = newValue
            }
        }
    }
    
    
    var limitsFat : Double? {
        get {
            if let fat = settingsInFirebase?[KeysForFirebase.LIMIT_FAT] {
                return fat as? Double
            } else {
                return 0.0
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
    
    
    var limitsFruit : Double? {
        get {
            if let fruit = settingsInFirebase?[KeysForFirebase.LIMIT_FRUIT] {
                return fruit as? Double
            } else {
                return 0.0
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
    
    var limitsStarch : Double? {
        get {
            if let starch = settingsInFirebase?[KeysForFirebase.LIMIT_STARCH] {
                return starch as? Double
            } else {
                return 0.0
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
    
    var limitsVeggies : Double? {
        get {
            if let veggies = settingsInFirebase?[KeysForFirebase.LIMIT_VEGGIES] {
                return veggies as? Double
            } else {
                return 0.0
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
    
  
    var journalWaterConsumed : Int? {
        get {
            if let water = journalInFirebase?[KeysForFirebase.GLASSES_OF_WATER] {
                return water as? Int
            } else {
                return 0
            }
        }
        
        set {
            if settingsInFirebase == nil {
                NSLog("settings doesn't exist in set journalWaterConsumed")
            } else {
                updateChildOfRecordInFirebase(fireBaseTable: KeysForFirebase.TABLE_JOURNAL, fireBaseRecordID: firebaseDateKey, fireBaseChildPath: KeysForFirebase.GLASSES_OF_WATER, value: newValue!)
                journalInFirebase?[KeysForFirebase.GLASSES_OF_WATER] = newValue
            }
        }
    }

    var journalWeight : Double? {
        get {
            if let weight = settingsInFirebase?[KeysForFirebase.WEIGHED] {
                return weight as? Double
            } else {
                return 0.0
            }
        }
        
        set {
            if settingsInFirebase == nil {
                NSLog("settings doesn't exist in set journalWeight")
            } else {
                updateChildOfRecordInFirebase(fireBaseTable: KeysForFirebase.TABLE_JOURNAL, fireBaseRecordID: firebaseDateKey, fireBaseChildPath: KeysForFirebase.WEIGHED, value: newValue!)
                journalInFirebase?[KeysForFirebase.WEIGHED] = newValue
            }
        }
    }

    var journalExercise : Int? {
        get {
            if let exercise = settingsInFirebase?[KeysForFirebase.EXERCISED] {
                return exercise as? Int
            } else {
                return 0
            }
        }
        
        set {
            if settingsInFirebase == nil {
                NSLog("settings doesn't exist in set journalExercise")
            } else {
                updateChildOfRecordInFirebase(fireBaseTable: KeysForFirebase.TABLE_JOURNAL, fireBaseRecordID: firebaseDateKey, fireBaseChildPath: KeysForFirebase.WEIGHED, value: newValue!)
                journalInFirebase?[KeysForFirebase.WEIGHED] = newValue
            }
        }
    }

    var journalSupplements : Int? {
        get {
            if let exercise = settingsInFirebase?[KeysForFirebase.SUPPLEMENTS] {
                return exercise as? Int
            } else {
                return 0
            }
        }
        
        set {
            if settingsInFirebase == nil {
                NSLog("settings doesn't exist in set journalExercise")
            } else {
                updateChildOfRecordInFirebase(fireBaseTable: KeysForFirebase.TABLE_JOURNAL, fireBaseRecordID: firebaseDateKey, fireBaseChildPath: KeysForFirebase.WEIGHED, value: newValue!)
                journalInFirebase?[KeysForFirebase.WEIGHED] = newValue
            }
        }
    }
    // MARK - Meal management
    
    func newDay() {
        
    }
    
    func oldDay(dateOfmeal mealDate : String) {
        
    }
    
     // MARK - Convenience methods for displaying properties in views
    
//    func targetWeigthString() -> String {
//        if targetWeight != nil {
//            return String(format:"%.1f", targetWeight!)
//        }
//            return "0.0"
//    }
//
//    func targetDateString() -> String {
//        return (targetDate?.makeShortStringDate())!
//    }
//
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
    
    func updateSettings(newSettings settings : Dictionary<String, Any?>) {
        for (newSettingsKey, newSettingsValue) in settings {
            switch (newSettingsKey) {
            case KeysForFirebase.LIMIT_PROTEIN_LOW:
                limitsProteinLow = newSettingsValue as? Double
            case  KeysForFirebase.LIMIT_FAT:
                limitsFat = newSettingsValue as? Double
            case KeysForFirebase.LIMIT_STARCH:
                limitsStarch = newSettingsValue as? Double
            case KeysForFirebase.LIMIT_FRUIT:
                limitsFruit = newSettingsValue as? Double
            case KeysForFirebase.LIMIT_VEGGIES:
                limitsVeggies = newSettingsValue as? Double
            case KeysForFirebase.LIMIT_PROTEIN_HIGH:
                limitsProteinHigh = newSettingsValue as? Double
            default:
                NSLog("Bad key in updateSettings")
            }
        }
    }
    
    
}





