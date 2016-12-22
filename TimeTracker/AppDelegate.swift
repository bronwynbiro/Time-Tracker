import UIKit

/**
 Application appDelegate that is responsible for loading the application.
 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    class AppDelegate: UIResponder, UIApplicationDelegate {
        
        var window: UIWindow?
        func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            return true
        }
    }
    
    /**
     Save app's state to load it back when the user comes back.
     - parameter application: application
     */
    // Save app's state to load it back when the user comes back.
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("application will resign active...")
        UserDefaults.standard.synchronize()
        let quitActivityRunning =
            UserDefaults.standard.bool(forKey: "quitActivityRunning")
        UserDefaults.standard.synchronize()
        //set the time of exiting app to calculate time it was in background later
        let currDate = Date()
        if quitActivityRunning == true {
            UserDefaults.standard.set(currDate as Date, forKey:"quitDate")
        }
        UserDefaults.standard.synchronize()
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
         print("did enter background app goes in.")
         UserDefaults.standard.synchronize()
         NotificationCenter.default.post(name: Notification.Name(rawValue: "AppDidEnterBackground"), object: nil)
         let quitActivityRunning =
         UserDefaults.standard.bool(forKey: "quitActivityRunning")
         UserDefaults.standard.synchronize()
         let currDate = Date()
         if quitActivityRunning == true {
         UserDefaults.standard.set(currDate as Date, forKey:"quitDate")
         UserDefaults.standard.synchronize()
         }
         UserDefaults.standard.synchronize()
         print("quitActivityRunning?", quitActivityRunning)
         print("currdate", currDate)
         
    }
    
    
    //  Loads the passed seconds if the timer was active when the app was closed.
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("app did become active..")
        let currDate = Date()
        let quitActivityRunning = UserDefaults.standard.object(forKey: "quitActivityRunning") as? Bool
        if quitActivityRunning == true {
            //retrieve time of exit, calculate time in background, set
            let quitDate = UserDefaults.standard.object(forKey: "quitDate") as! Date
            print("quit date became activ:", quitDate)
            let passedSec = currDate.timeIntervalSince(quitDate)
            UserDefaults.standard.set(passedSec, forKey: "secondsInBackground")
            print("passed seconds active:", passedSec)
            UserDefaults.standard.synchronize()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("app will enter foreground..")
        let currDate = Date()
        let quitActivityRunning = UserDefaults.standard.object(forKey: "quitActivityRunning") as? Bool
        if quitActivityRunning == true {
            //retrieve time of exit, calculate time in background, set
            let quitDate = UserDefaults.standard.object(forKey: "quitDate") as! Date
            print("quit date in will enter foreground:", quitDate)
            let passedSec = currDate.timeIntervalSince(quitDate)
            UserDefaults.standard.set(passedSec, forKey: "secondsInBackground")
            print("passed seconds will enter foreground:", passedSec)
            UserDefaults.standard.synchronize()
            
        }
    }
    
    /**
     Save core data context if the app is closed.
     - parameter application: application
     */
    func applicationWillTerminate(_ application: UIApplication) {
        print("app will terminate..")
        UserDefaults.standard.synchronize()
        let quitActivityRunning =
            UserDefaults.standard.bool(forKey: "quitActivityRunning")
        UserDefaults.standard.synchronize()
        //set the time of exiting app to calculate time it was in background later
        let currDate = Date()
        if quitActivityRunning == true {
            UserDefaults.standard.set(currDate as Date, forKey:"quitDate")
            UserDefaults.standard.synchronize()
        }
        UserDefaults.standard.synchronize()
    }
    
    
}
