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
        func applicationWillResignActive(application: UIApplication) {
            print("application will resign active...")
            NSUserDefaults.standardUserDefaults().synchronize()
    
            CoreDataHandler.sharedInstance.saveContext()
            let isActivityPaused = NSUserDefaults.standardUserDefaults().boolForKey("quitActivityPaused") as! Bool
            
            NSUserDefaults.standardUserDefaults().synchronize()
            if isActivityPaused == false {
            var currDate = NSDate()
            NSUserDefaults.standardUserDefaults().setObject(currDate as NSDate, forKey:"quitDate")
                
            NSUserDefaults.standardUserDefaults().synchronize()
            let test = NSUserDefaults.standardUserDefaults().objectForKey("quitDate") as! NSDate
                
            NSUserDefaults.standardUserDefaults().synchronize()
            print("test?", test )
            }
            NSUserDefaults.standardUserDefaults().synchronize()
            print("isactiv?", isActivityPaused)
    }

        func applicationDidEnterBackground(application: UIApplication) {
         print("did enter background app goes in.")
         NSUserDefaults.standardUserDefaults().synchronize()
         NSNotificationCenter.defaultCenter().postNotificationName("AppDidEnterBackground", object: nil)
            CoreDataHandler.sharedInstance.saveContext()
            let isActivityPaused =
                NSUserDefaults.standardUserDefaults().boolForKey("quitActivityPaused")
                NSUserDefaults.standardUserDefaults().synchronize()
           if isActivityPaused == false {
                let currDate = NSDate()
                NSUserDefaults.standardUserDefaults().setObject(currDate as NSDate, forKey:"quitDate")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            NSUserDefaults.standardUserDefaults().synchronize()
                print("isactiv?", isActivityPaused)
        }
    
    /**
        Loads the passed seconds if the timer was active when the app was closed.

        - parameter application: application
 
    func applicationDidBecomeActive(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName("AppBecameActive", object: nil)
        
    }
    */
    
    func applicationDidBecomeActive(application: UIApplication) {
        print("app did become active..")
        let isActivityPaused = NSUserDefaults.standardUserDefaults().objectForKey("quitActivityPaused") as? Bool
        let getQuitDate = NSUserDefaults.standardUserDefaults().objectForKey("quitDate") as? NSDate ?? NSDate()
       if isActivityPaused == false  {
            let passedSec = NSUserDefaults.standardUserDefaults().objectForKey("passedSeconds") as? Int
        NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        /*
         MARK: update labels
            let minutes = (passedSec / 60) % 60
            let hours = (passedSec) / 3600
            minutesLabel.text = NSString.timeStringWithTimeToDisplay(minutes)
            hoursLabel.text = NSString.timeStringWithTimeToDisplay(hours)
 */
            

        }

    /**
        Save core data context if the app is closed.

        - parameter application: application
    */
    func applicationWillTerminate(application: UIApplication) {
        CoreDataHandler.sharedInstance.saveContext()
        }


}