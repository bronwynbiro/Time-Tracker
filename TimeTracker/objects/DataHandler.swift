import Foundation
import UIKit
import RealmSwift

let realm = try! Realm()

class dataHandler: Object {
    
    
    /**
     Tells whether the passed in activity's name is already saved or not.
     - parameter activityName: activityName activity to be saved.
     - returns: BOOL boolean value determining whether the activity is already in core data or not.
     */
    func isDuplicate(activityName: String) -> Bool {
        let objects = realm!.objects(Activity.self).filter("name = %@", activityName)
        return objects.count != 0
    }
    
    /**
     Creates a NSDateFormatter to format the dates of the Route object
     - returns: NSDateFormatter the dateFormatter object
     */
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()
    
    /*
     Adds new activity to core data.
     - parameter name: name activity name to be saved.
     */
    func addNewActivityName(name: String) {
        let newActivity = Activity()
        newActivity.name = "\(name)"
    
        try! realm!.write {
            realm!.add(newActivity)
        }
        newActivity.name = name
    }
    
    /**
     Save new history object to core data.
     - parameter name:      name of the activity
     - parameter startDate: when the activity started
     - parameter endDate:   when it was finished
     - parameter duration:  duration of the activity
     */
    /*
     //TODO: potentially unnecessary if realm autosaves?
    func saveHistory(name: String, startDate: NSDate, endDate: NSDate, duration: NSInteger) {
        let history = History()
        history.name = name
        history.startDate = startDate as Date
        history.endDate = endDate as Date
        history.duration = duration as NSNumber?
        history.saveTime = dateFormatter.string(from: endDate as Date)
        try! realm!.write {
            realm!.create(history)
        }
        
    }
 */
    
    /**
     Save updated history object to core data.
     
     - parameter name:      name of the activity
     - parameter startDate: when the activity started
     - parameter endDate:   when it was finished
     - parameter duration:  duration of the activity
     */
    
    func updateHistory(name: String, startDate: NSDate, endDate: NSDate, duration: NSInteger, PassPath: NSIndexPath, PassHistory: History) {
        //    let history: History = NSEntityDescription.insertNewObjectForEntityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext) as! History
        let history = PassHistory
        history.name = name
        history.startDate = startDate as Date
        history.endDate = endDate as Date
        
        let calendar = NSCalendar.current
        let dateMakerFormatter = DateFormatter()
        dateMakerFormatter.dateFormat = "hh:mm a"
        let timeDifference = calendar.dateComponents([.hour, .minute], from: startDate as Date, to: endDate as Date)
      //  let durationString = "\(timeDifference)"
        let interval = endDate.timeIntervalSince(startDate as Date)
        try! realm?.write {
            realm?.add(history)
            history.duration = interval as NSNumber?
            history.saveTime = dateFormatter.string(from: endDate as Date)
        }
    }
    
    
    /**
     Fetch core data to get all history objects.
     - returns: array of history objects
     */
    func allHistoryItems() -> Results<History>? {
        let allHistory = realm?.objects(History.self).sorted(byProperty: "startDate")
        return allHistory!
    }
    
    
    func fetchDataForTodayActivities() -> Results<History>{
        let startDate = Date.dateByMovingToBeginningOfDay()
        let endDate = Date.dateByMovingToEndOfDay()
        let todayActivities = realm?.objects(History.self).filter("(startDate >= %@) AND (startDate <= %@)", startDate, endDate).sorted(byProperty: "startDate")
        return todayActivities!
    }
    
    
    func fetchDataForWeekActivities() -> Results<History> {
        let startDate = Date.dateSevenDaysAgo()
        let endDate = Date.dateByMovingToEndOfDay()
        let weekActivities = realm?.objects(History.self).filter("(startDate >= %@) AND (startDate <= %@)", startDate, endDate).sorted(byProperty: "startDate")
        return weekActivities!
    }
    
    func fetchDataForMonthActivities() -> Results<History> {
        let startDate = Date.dateMonthAgo()
        let endDate = Date.dateByMovingToEndOfDay()
        let monthActivities = realm?.objects(History.self).filter("(startDate >= %@) AND (startDate <= %@)", startDate, endDate).sorted(byProperty: "startDate")
        return monthActivities!
    }
    

    func fetchDataAllActivities() -> Results<Activity> {
        //TODO ascending = true
        let allActivities = realm?.objects(Activity.self).sorted(byProperty: "name")
        return allActivities!
    }
    

    func filterResultsMonth(i: String)-> Results<History> {
        let startDate = Date.dateMonthAgo()
        let endDate = Date.dateByMovingToEndOfDay()
        let monthActivities = realm?.objects(History.self).filter("(startDate >= %@) AND (startDate <= %@ AND (name = %@))", startDate, endDate, i)
        return monthActivities!
       
    }
    
    func filterResultsWeek(i: String)-> Results<History> {
        let startDate = Date.dateSevenDaysAgo()
        let endDate = Date.dateByMovingToEndOfDay()
        let weekActivities = realm?.objects(History.self).filter("(startDate >= %@) AND (startDate <= %@ AND (name = %@))", startDate, endDate, i)
        return weekActivities!
    }
    
    func filterResultsDay(i: String)-> Results<History> {
        let startDate = Date.dateByMovingToBeginningOfDay()
        let endDate = Date.dateByMovingToEndOfDay()
        let todayActivities = realm?.objects(History.self).filter("(startDate >= %@) AND (startDate <= %@ AND (name = %@))", startDate, endDate, i)
        return todayActivities!
    }

    func deleteObject(objectToDelete: Object) {
            try! realm?.write {
                realm?.delete(objectToDelete)
            }
        }
    
    /*
    func deleteObjects(objectsToDelete: [NSManagedObject]) {
    }
 */

 }
    
