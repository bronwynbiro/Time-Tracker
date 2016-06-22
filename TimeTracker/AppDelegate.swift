//
//  AppDelegate.swift
//  TimeTracker
// V1

import UIKit
import CoreData

/**
 Application appDelegate that is responsible for loading the application.
 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    class AppDelegate: UIResponder, UIApplicationDelegate {
        
        var window: UIWindow?
        func application(application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            return true
        }
        
        /**
         Save app's state to load it back when the user comes back.
         
         - parameter application: application
         */
        func applicationDidEnterBackground(application: UIApplication) {
            NSNotificationCenter.defaultCenter().postNotificationName("AppDidEnterBackground", object: nil)
            //MARK: save coredata too
            CoreDataHandler.sharedInstance.saveContext()
        }
        
        /**
         Loads the passed seconds if the timer was active when the app was closed.
         
         - parameter application: application
         */
        func applicationDidBecomeActive(application: UIApplication) {
            NSNotificationCenter.defaultCenter().postNotificationName("AppBecameActive", object: nil)
        }
        
        /**
         Save core data context if the app is closed.
         
         - parameter application: application
         */
        func applicationWillTerminate(application: UIApplication) {
            CoreDataHandler.sharedInstance.saveContext()
        }
        
    }
    
}