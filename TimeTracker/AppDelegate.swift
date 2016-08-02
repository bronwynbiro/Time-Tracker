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
    class AppDelegate: UIResponder, UIApplicationDelegate {
        
        var window: UIWindow?
        func application(application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
        }
    }

    /**
        Save app's state to load it back when the user comes back.

        - parameter application: application
    */
    // Save app's state to load it back when the user comes back.
    
    func applicationWillResignActive(application: UIApplication) {
        print("application will resign active...")
        NSUserDefaults.standardUserDefaults().synchronize()
        CoreDataHandler.sharedInstance.saveContext()
        let quitActivityRunning =
            NSUserDefaults.standardUserDefaults().boolForKey("quitActivityRunning")
        NSUserDefaults.standardUserDefaults().synchronize()
        //set the time of exiting app to calculate time it was in background later
        let currDate = NSDate()
        if quitActivityRunning == true {
            NSUserDefaults.standardUserDefaults().setObject(currDate as NSDate, forKey:"quitDate")
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    
    func applicationDidEnterBackground(application: UIApplication) {
        /*
        print("did enter background app goes in.")
        NSUserDefaults.standardUserDefaults().synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName("AppDidEnterBackground", object: nil)
        CoreDataHandler.sharedInstance.saveContext()
        let quitActivityRunning =
            NSUserDefaults.standardUserDefaults().boolForKey("quitActivityRunning")
        NSUserDefaults.standardUserDefaults().synchronize()
        let currDate = NSDate()
        if quitActivityRunning == true {
            NSUserDefaults.standardUserDefaults().setObject(currDate as NSDate, forKey:"quitDate")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        NSUserDefaults.standardUserDefaults().synchronize()
        print("quitActivityRunning?", quitActivityRunning)
        print("currdate", currDate)
 */
    }
    
    
    //  Loads the passed seconds if the timer was active when the app was closed.
    
    func applicationDidBecomeActive(application: UIApplication) {
        print("app did become active..")
        let currDate = NSDate()
        let quitActivityRunning = NSUserDefaults.standardUserDefaults().objectForKey("quitActivityRunning") as? Bool
        if quitActivityRunning == true {
            //retrieve time of exit, calculate time in background, set
            let quitDate = NSUserDefaults.standardUserDefaults().objectForKey("quitDate") as! NSDate
            print("quit date in deleg:", quitDate)
            let passedSec = currDate.timeIntervalSinceDate(quitDate)
            NSUserDefaults.standardUserDefaults().setDouble(passedSec, forKey: "secondsInBackground")
            print("passed seconds deleg:", passedSec)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        print("app will enter foreground..")
        let currDate = NSDate()
        let quitActivityRunning = NSUserDefaults.standardUserDefaults().objectForKey("quitActivityRunning") as? Bool
        if quitActivityRunning == true {
            //retrieve time of exit, calculate time in background, set
            let quitDate = NSUserDefaults.standardUserDefaults().objectForKey("quitDate") as! NSDate
            print("quit date in deleg:", quitDate)
            let passedSec = currDate.timeIntervalSinceDate(quitDate)
            NSUserDefaults.standardUserDefaults().setDouble(passedSec, forKey: "secondsInBackground")
            print("passed seconds deleg:", passedSec)
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
    }
    
    /**
     Save core data context if the app is closed.
     - parameter application: application
     */
    func applicationWillTerminate(application: UIApplication) {
        print("app will terminate..")
        CoreDataHandler.sharedInstance.saveContext()
        NSUserDefaults.standardUserDefaults().synchronize()
        CoreDataHandler.sharedInstance.saveContext()
        let quitActivityRunning =
            NSUserDefaults.standardUserDefaults().boolForKey("quitActivityRunning")
        NSUserDefaults.standardUserDefaults().synchronize()
        //set the time of exiting app to calculate time it was in background later
        let currDate = NSDate()
        if quitActivityRunning == true {
            NSUserDefaults.standardUserDefaults().setObject(currDate as NSDate, forKey:"quitDate")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
}