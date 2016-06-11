//
//  AppDelegate.swift
//  TimeTracker
// V1

import UIKit

/**
    Application appDelegate that is responsible for loading the application.
*/

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /**
    Initializes the app.
    - parameter application: The delegating application object.
    - parameter launchOptions: A dictionary indicating the reason the application was launched (if any). The contents of this dictionary may be empty in situations where the user launched the application directly. For information about the possible keys in this dictionary and how to handle them, see “Launch Options Keys”.
    - returns: NO if the application cannot handle the URL resource, otherwise return YES. The return value is ignored if the application is launched as a result of a remote notification.
    */
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
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

