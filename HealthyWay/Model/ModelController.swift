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
    // master data
    var signedinUID : String?
    var signedinEmail : String?
    var signedinUserDataNode : [String : Any?] = [:]
    var signedinUserErrorMessages : String = ""
    var nameOfDevice : String?
    // MARK: - state of Firebase
    var isFirebaseConnected : Bool = false
    var isSettingsNodeChanged : Bool = false
    // MARK: - Firebase callbacks
    var closureForIsConnectedHandler : (()->Void)?
    var closureForIsConnectedError : ((String)->Void)?

    
    
    func startModel() {
        nameOfDevice = UIDevice.current.name
        // initialize master node and its state
        ref = Database.database().reference()
        ref.removeAllObservers()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            let connectedRef = Database.database().reference(withPath: ".info/connected")
            connectedRef.observe(.value, with: {snapshot in
                if snapshot.value as? Bool ?? false {
                    if let uid = self.currentUID {
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
    
    
    
    func successfullStartOfFirebase() {
        if let uid = currentUID {
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

    
    // MARK: - inflight storage on UserDefaults
    var currentUID : String? {
        get {
            return UserDefaults.standard.string(forKey: Constants.CURRENT_UID)
        }
        
        set{
            UserDefaults.standard.set(newValue, forKey: Constants.CURRENT_UID)
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
            print("error in updateChildInFirebase")
        }
    }
    
    func updateChildOfRecordInFirebase(fireBaseTable table : String, fireBaseRecordID recordID : String, fireBaseChildPath path : String, value : Any) {
        let fullFirebasePath : String? = table + "/" + recordID + "/" + path
        if fullFirebasePath != nil {
            ref.child(fullFirebasePath!).setValue(value)
        } else {
            print("error in updateChildOfRecordInFirebase")
        }
        
    }
    
//    func updateSettings(newSettings settings : Dictionary<String, Any?>) {
//        for (newSettingsKey, newSettingsValue) in settings {
//            switch (newSettingsKey) {
//            case KeysForFirebase.LIMIT_PROTEIN_LOW:
//                limitsProteinLow = newSettingsValue as? Double
//            case  KeysForFirebase.LIMIT_FAT:
//                limitsFat = newSettingsValue as? Double
//            case KeysForFirebase.LIMIT_STARCH:
//                limitsStarch = newSettingsValue as? Double
//            case KeysForFirebase.LIMIT_FRUIT:
//                limitsFruit = newSettingsValue as? Double
//            case KeysForFirebase.LIMIT_VEGGIES:
//                limitsVeggies = newSettingsValue as? Double
//            case KeysForFirebase.LIMIT_PROTEIN_HIGH:
//                limitsProteinHigh = newSettingsValue as? Double
//            default:
//                print("Bad key in updateSettings")
//            }
//        }
//    }
//    
    // MARK - Authentication
    
    func loginUser(email : String, password : String, errorHandler : @escaping (_ : String) -> Void,  handler : @escaping ()-> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // ...
            if user == nil {
                errorHandler((error?.localizedDescription)!)
            } else {
                self.signedinUID = user?.user.uid
                self.signedinEmail = user?.user.email
                self.currentUID = user?.user.uid
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
            self.currentUID = nil
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
            self.currentUID = nil
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
    // Used by Healthy Way Admin app
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
                self.currentUID = nil
                errorHandler(firebaseError)
            } else {
                self.currentUID = self.signedinUID
                handler()
            }
        }
    }
                
    func createUserInUsersNode(userUID uid : String, userEmail email : String, errorHandler : @escaping (_ : String) -> Void,  handler : @escaping ()-> Void) {
        self.ref.child("users").child(uid).setValue(["email": email, "isAdmin": false]) {  // no user can be admin
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
        if signedinUserDataNode.count == 0 {
            let userDataRef = self.ref.child("userData").child(signedinUID!)
            userDataRef.observeSingleEvent(of: .value, with:
                { (snapshot)
                    in
                    self.signedinUserDataNode = snapshot.value as? [String : Any?] ?? [:]
                    self.signedinUserErrorMessages = ""
                    handler()
            }) { (error) in
                self.signedinUserErrorMessages = "Encountered error, " + error.localizedDescription +
                ", searching for client data"
                errorHandler(self.clientErrorMessages)
            }
        } else {
            handler()
        }
    }
    
    
    func setNodeUserData(userDataNode node : [String : Any?], errorHandler : @escaping (_ : String) -> Void, handler : @escaping ()-> Void) {
        self.ref.child(KeysForFirebase.NODE_USERDATA).child(signedinUID!).setValue(node) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                errorHandler(error.localizedDescription)
            } else {
                self.signedinUserDataNode = node
                self.signedinUserErrorMessages = ""
                handler()
            }
        }
        
    }
    

    
    
}





