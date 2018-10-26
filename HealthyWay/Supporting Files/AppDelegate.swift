//
//  AppDelegate.swift
// HealthyWay
//
//  Created by Bill Weatherwax on 7/4/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var model = ModelController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        model.closureForIsConnectedHandler = showFirstViewController
        model.closureForIsConnectedError = noFirebaseAlert
        model.startModel()
        return true
    }
    
    func noFirebaseAlert(error errorMessage : String) {
        print(errorMessage)
        let alert = UIAlertController(title: "Offline warning: quit the app or use in offline mode (some features disabled)", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Quit", style: .default, handler: { action in
            switch action.style{
            case .default:
                UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                       to: UIApplication.shared, for: nil)
            case .cancel:
                print("Error in no Firebase Alert because cancel returned")
                
            case .destructive:
                print("Error in datepicker no Firebase because destructive returned")
                
                
            }}))
        alert.addAction(UIAlertAction(title: "Offline mode", style: .cancel, handler: { action in
            switch action.style{
            case .default:
                print("Error in no Firebase Alert because default returned")
            case .cancel:
                self.showFirstViewController()

                
            case .destructive:
                print("Error in no Firebase Alert because destructive returned")
            }}))
        model.closureForIsConnectedError = nil
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    

    func showFirstViewController(){
        // Set the window to the dimensions of the device
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // Grab a reference to whichever storyboard you have the ViewController within
        let storyboard = UIStoryboard(name: Constants.MAIN, bundle: nil)
        
        // Grab a reference to the ViewController you want to show 1st.
        var initialViewController = UIViewController()
        initialViewController = storyboard.instantiateViewController(withIdentifier: Constants.SIGNIN_VC) // HealthyWayTabBarControllerID
        // Set that ViewController as the rootViewController
        self.window?.rootViewController = initialViewController
        // Make sure correct view controller loaded
        if let vc = window?.rootViewController as? SignInViewController { // start with Signin
            vc.modelController = model
        } else {
            print("Problem in AppDelegate.swift")
        }
        //        }
        
        // Set that ViewController as the rootViewController
        self.window?.rootViewController = initialViewController
        
        // Make sure correct view controller loaded
        if let vc = window?.rootViewController as? SignInViewController { // start with Signin
            vc.modelController = model
        }
        
        // Sets our window up in front
        self.window?.makeKeyAndVisible()
        
        // inactivate Firebase closure
        model.closureForIsConnectedHandler = nil
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        model.stopModel()
    }


}

