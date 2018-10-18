//
//  ModelController.swift
// HealthyWay
//
//  Created by Bill Weatherwax on 7/5/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import HealthyWayFramework

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
    var clientNode : [String : Any?] = [:] // key is node type journal, settings, and mealContent
    var clientErrorMessages : String = ""
    var signedinUID : String?
    var signedinEmail : String?
    var signedinUserDataNode : [String : Any?] = [:]
    var signedinUserErrorMessages : String = ""
    // MARK: - state of Firebase
    var isFirebaseConnected : Bool = false
    // MARK: - Firebase callbacks
    var closureForIsConnectedHandler : (()->Void)?
    var closureForIsConnectedError : ((String)->Void)?
    
    func startModel() {
        ref = Database.database().reference()
        ref.removeAllObservers()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            let connectedRef = Database.database().reference(withPath: ".info/connected")
            connectedRef.observe(.value, with: {snapshot in
                if snapshot.value as? Bool ?? false {
                    if let uid = UserDefaults.standard.string(forKey: Constants.CURRENT_UID) {
                        self.signedinUID = uid
                    } else {
                        self.signedinUID = nil
                        self.signedinEmail = nil
                    }
                    self.isFirebaseConnected = true
                    if self.closureForIsConnectedHandler == nil {
                        print("closure handler is nil")
                    } else {
                        self.closureForIsConnectedHandler!()
                    }
                } else {
                    self.isFirebaseConnected = false
                    if self.closureForIsConnectedError == nil {
                        print("closure error handler is nil")
                    } else {
                        self.closureForIsConnectedError!("\n\n*********\nNot connected to Firebase\n******\n\n")
                    }
                    
                }
            })
        })
    }
    
    
    
    
    
    func probleConnectingToFirebase(errorMessage messageText : String) {
        print(messageText)
    }
    
    func successfullStartOfFirebase() {
        if let uid = UserDefaults.standard.string(forKey: Constants.CURRENT_UID) {
            signedinUID = uid
        } else {
            signedinUID = nil
            signedinEmail = nil
        }
    }
    
    func stopModel(){
        ref.removeObserver(withHandle: refHandle)
    }
    
    func getDatabaseRef() -> DatabaseReference {
        return ref
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
        let settingsRef = ref.child(KeysForFirebase.NODE_SETTINGS)
        settingsHandle = settingsRef.observe(DataEventType.value, with: { (snapshot) in
            self.settingsInFirebase = snapshot.value as? [String : AnyObject] ?? [:]
        })

        let journalRef = ref.child(KeysForFirebase.NODE_JOURNAL)
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
        let mealContentsRef = ref.child(KeysForFirebase.NODE_MEAL_CONTENTS)
        mealContentsHandle = mealContentsRef.observe(DataEventType.value, with: { (snapshot) in
            self.mealContentsInFirebase = snapshot.value as? [String : AnyObject] ?? [:]
        })
    }
    func getJournal(journalOnDateKey date: String) {
        // date must be of the form YYYY-MM-DD or no match will be found
        let consumeRef = self.ref.child(KeysForFirebase.NODE_JOURNAL)
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
                updateChildInFirebase(fireBaseTable: KeysForFirebase.NODE_SETTINGS, fireBaseChildPath: KeysForFirebase.LIMIT_PROTEIN_LOW, value: newValue!)
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
                updateChildInFirebase(fireBaseTable: KeysForFirebase.NODE_SETTINGS, fireBaseChildPath: KeysForFirebase.LIMIT_PROTEIN_HIGH, value: newValue!)
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
                updateChildInFirebase(fireBaseTable: KeysForFirebase.NODE_SETTINGS, fireBaseChildPath: KeysForFirebase.LIMIT_FAT, value: newValue!)
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
                updateChildOfRecordInFirebase(fireBaseTable: KeysForFirebase.NODE_JOURNAL, fireBaseRecordID: firebaseDateKey, fireBaseChildPath: KeysForFirebase.GLASSES_OF_WATER, value: newValue!)
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
                updateChildOfRecordInFirebase(fireBaseTable: KeysForFirebase.NODE_JOURNAL, fireBaseRecordID: firebaseDateKey, fireBaseChildPath: KeysForFirebase.WEIGHED, value: newValue!)
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
                updateChildOfRecordInFirebase(fireBaseTable: KeysForFirebase.NODE_JOURNAL, fireBaseRecordID: firebaseDateKey, fireBaseChildPath: KeysForFirebase.WEIGHED, value: newValue!)
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
                updateChildOfRecordInFirebase(fireBaseTable: KeysForFirebase.NODE_JOURNAL, fireBaseRecordID: firebaseDateKey, fireBaseChildPath: KeysForFirebase.WEIGHED, value: newValue!)
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
    
    // MARK - Authentication
    
    func loginUser(email : String, password : String, errorHandler : @escaping (_ : String) -> Void,  handler : @escaping ()-> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // ...
            if user == nil {
                errorHandler((error?.localizedDescription)!)
            } else {
                self.signedinUID = user?.user.uid
                self.signedinEmail = user?.user.email
                UserDefaults.standard.set(user?.user.uid, forKey: Constants.CURRENT_UID)
                handler()
            }
        }
    }
 
    
    
    func signoutUser(errorHandler : @escaping (_ : String) -> Void) {
        if Auth.auth().currentUser?.displayName != nil {
            do {
                print("Signing out user: ", Auth.auth().currentUser?.displayName! ?? "unknown user")
                try Auth.auth().signOut()
                signedinUID = nil
                signedinEmail = nil
            } catch {
                errorHandler("Sign out failed")
            }
            UserDefaults.standard.set(nil, forKey: Constants.CURRENT_UID)
        }

    }
    func signoutUser(errorHandler : @escaping (_ : String) -> Void,  handler : @escaping ()-> Void) {
        if Auth.auth().currentUser?.uid != nil {
            do {
                print("Signing out user: ", Auth.auth().currentUser?.email! ?? "unknown user")
                try Auth.auth().signOut()
                signedinUID = nil
                signedinEmail = nil
                handler()
            } catch {
                errorHandler("Sign out failed")
            }
            UserDefaults.standard.set(nil, forKey: Constants.CURRENT_UID)
        }
        
    }

    func passwordReset(clientEmail email : String, errorHandler : @escaping (_ : String) -> Void, handler : @escaping () -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            // error
            if let checkError = error {
                let message = "Reset email failure: \(checkError.localizedDescription)"
                errorHandler(message)
            } else {
                handler()
            }
        }

    }
    
    func updatePassword(newPassword : String, errorHandler : @escaping (_ : String) -> Void, handler : @escaping () -> Void) {
        Auth.auth().currentUser?.updatePassword(to:newPassword) {(error) in
            if error != nil {
                let message = "Failed to update new password: \(error!.localizedDescription)"
                errorHandler(message)
            } else {
                handler()
            }
        }
    }
    
    
    
    func checkFirebaseConnected(errorHandler : @escaping (_ : String) -> Void, handler : @escaping () -> Void) -> Void {
        
        let healthywayDatabaseRef = ref
        let connectedRef = healthywayDatabaseRef.database.reference(withPath: ".info/connected")
        connectedRef.observeSingleEvent(of: .value, with: { snapshot in
            let result = snapshot.value as? Int ?? -1
            if result == 0 {
                print("Connected to Firebase")
            } else {
                print("Not connected to Firebase")
            }
           handler()
        })
    }
    
    func getNodeOfClient(email : String, errorHandler : @escaping (_ : String) -> Void,  handler : @escaping ()-> Void) {
        clientNode = [:]
        clientErrorMessages = ""
        let firebaseEmail = makeFirebaseEmailKey(email: email)
        let emailsRef = ref.child("emails").child(firebaseEmail)
        emailsRef.observeSingleEvent(of: .value, with:  { (snapshot)
            in
            let nodeEmailsValue = snapshot.value as? [String : Any?] ?? [:]
            let clientUID = nodeEmailsValue["uid"] as? String
            if clientUID == nil {
                self.clientErrorMessages = "No client found with that email address"
                errorHandler(self.clientErrorMessages)
            }
            let usersRef = self.ref.child("users").child(clientUID!)
            usersRef.observeSingleEvent(of: .value, with:  { (snapshot)
                in
                let nodeUsersValue = snapshot.value as? [String : Any?] ?? [:]
                let userEmail = nodeUsersValue["email"] as? String
                let checkEmail = restoreEmail(firebaseEmailKey: userEmail!)
                if checkEmail == email {
                    let userDataRef = self.ref.child("userData").child(clientUID!)
                    userDataRef.observeSingleEvent(of: .value, with:
                        { (snapshot)
                            in
                            self.clientNode = snapshot.value as? [String : Any?] ?? [:]
                            handler()
                    }) { (error) in
                        self.clientErrorMessages = "Encountered error, " + error.localizedDescription +
                        ", searching for client data"
                        errorHandler(self.clientErrorMessages)
                    }
                } else {
                    self.clientErrorMessages = "Mismatch between emails and uids."
                    errorHandler(self.clientErrorMessages)
                }
            }) { (error) in
                self.clientErrorMessages = "Encountered error, " + error.localizedDescription + ", searching for client UID"
                errorHandler(self.clientErrorMessages)
            }
        })  { (error) in
            self.clientErrorMessages = "Encountered error, " + error.localizedDescription + ", searching for client email"
            errorHandler(self.clientErrorMessages)
        }
    }

    func createAuthUserNode(userEmail emailEntered : String, userPassword passwordEntered : String, errorHandler : @escaping (_ : String) -> Void,  handler : @escaping ()-> Void) {
        Auth.auth().createUser(withEmail: emailEntered, password: passwordEntered) { (authResult, error) in
            // ...
            self.signedinUID = authResult?.user.uid
            self.signedinEmail = authResult?.user.email
            if self.signedinUID == nil {
                let firebaseError = "Account creation failed: "
                    + (error?.localizedDescription)!
                UserDefaults.standard.set(nil, forKey: Constants.CURRENT_UID)
                errorHandler(firebaseError)
            } else {
                UserDefaults.standard.set(self.signedinUID, forKey: Constants.CURRENT_UID)
                handler()
            }
        }
    }
                
    func createUserInUsersNode(userUID uid : String, userEmail email : String, errorHandler : @escaping (_ : String) -> Void,  handler : @escaping ()-> Void) {
        self.ref.child("users").child(uid).setValue(["email": email, "isAdmin": true]) {
            (error:Error?, ref:DatabaseReference) in
            if let checkError = error {
                errorHandler("Account creation failed: \(checkError).")
                return
            } else {
                handler()
            }
        }
    }
    
    func createEmailInEmailsNode(userUID uid : String, userEmail email : String, errorHandling : @escaping (_ : String) -> Void, handler : @escaping () -> Void) {
        let keyEmail = makeFirebaseEmailKey(email: email)
        self.ref.child("emails").child(keyEmail).setValue(["uid" : uid]) {
            (error : Error?, ref: DatabaseReference) in
                if let checkError = error {
                    errorHandling("Email creation failed:\(checkError).")
                    return
                } else {
                    handler()
            }
        }
    }

    
    func getNodeUserData(errorHandler : @escaping (_ : String) -> Void,  handler : @escaping ()-> Void) {
        signedinUserDataNode = [:]
        signedinUserErrorMessages = ""
        let userDataRef = self.ref.child("userData").child(signedinUID!)
        userDataRef.observeSingleEvent(of: .value, with:
            { (snapshot)
                in
                self.signedinUserDataNode = snapshot.value as? [String : Any?] ?? [:]
                handler()
        }) { (error) in
            self.signedinUserErrorMessages = "Encountered error, " + error.localizedDescription +
            ", searching for client data"
            errorHandler(self.clientErrorMessages)
        }
    }
    
    
    func setNodeUserData(userDataNode node : [String : Any?], errorHandler : @escaping (_ : String) -> Void, handler : @escaping ()-> Void) {
        self.ref.child(KeysForFirebase.NODE_USERDATA).child(signedinUID!).setValue(node) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                errorHandler(error.localizedDescription)
            } else {
                handler()
            }
        }
        
    }
    
}





