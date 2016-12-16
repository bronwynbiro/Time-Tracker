import UIKit
import CoreData

class CoreDataHandler: NSObject {
    
    /**
     Tells whether the passed in activity's name is already saved or not.
     - parameter activityName: activityName activity to be saved.
     - returns: BOOL boolean value determining whether the activity is already in core data or not.
     */
    func isDuplicate(_ activityName: String) -> Bool {
        let entityDescription = NSEntityDescription.entityForName("Activity", inManagedObjectContext: self.backgroundManagedObjectContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        let predicate = NSPredicate(format: "name = %@", activityName)
        request.predicate = predicate
        do {
            let objects = try self.backgroundManagedObjectContext.executeFetchRequest(request)
            return objects.count != 0
        } catch {
            // Error occured
            return false
        }
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
    
    /**
     Adds new activity to core data.
     - parameter name: name activity name to be saved.
     */
    func addNewActivityName(_ name: String) {
        let newActivity = NSEntityDescription.insertNewObjectForEntityForName("Activity", inManagedObjectContext: self.backgroundManagedObjectContext) as! Activity
        newActivity.name = name
        saveContext()
    }
    
    /**
     Save new history object to core data.
     - parameter name:      name of the activity
     - parameter startDate: when the activity started
     - parameter endDate:   when it was finished
     - parameter duration:  duration of the activity
     */
    func saveHistory(_ name: String, startDate: Date, endDate: Date, duration: NSInteger) {
        let history: History = NSEntityDescription.insertNewObjectForEntityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext) as! History
        history.name = name
        history.startDate = startDate
        history.endDate = endDate
        history.duration = duration as NSNumber?
        history.saveTime = dateFormatter.string(from: endDate)
        saveContext()
    }
    
    /**
     Save updated history object to core data.
     
     - parameter name:      name of the activity
     - parameter startDate: when the activity started
     - parameter endDate:   when it was finished
     - parameter duration:  duration of the activity
     */
    
    func updateHistory(_ name: String, startDate: Date, endDate: Date, duration: NSInteger, PassPath: IndexPath, PassHistory: History) {
        //    let history: History = NSEntityDescription.insertNewObjectForEntityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext) as! History
        let history = PassHistory
        history.name = name
        history.startDate = startDate
        history.endDate = endDate
        //calculate new duration
        let calendar = Calendar.current
        let dateMakerFormatter = DateFormatter()
        dateMakerFormatter.dateFormat = "hh:mm a"
        let startTime = startDate
        let endTime = endDate
        let hourMinuteComponents: NSCalendar.Unit = [.hour, .minute]
        let timeDifference = (calendar as NSCalendar).components(
            hourMinuteComponents,
            from: startTime,
            to: endTime,
            options: [])
        let durationString = "\(timeDifference)"
        let interval = endDate.timeIntervalSince(startDate)
        history.duration = interval as NSNumber?
        history.saveTime = dateFormatter.string(from: endDate)
        saveContext()
    }
    
    
    /**
     Fetch core data to get all history objects.
     - returns: array of history objects
     */
    func allHistoryItems() -> [History]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext)
        fetchRequest.entity = entityDescription
        
        let dateDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
        fetchRequest.sortDescriptors = [dateDescriptor]
        
        return (fetchCoreDataWithFetchRequest(fetchRequest) as! [History])
    }
    
    /**
     Fetch core data for activities for today
     - returns: array of History objects
     */
    func fetchCoreDataForTodayActivities() -> [History] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext)
        fetchRequest.entity = entityDescription
        
        let dateDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
        fetchRequest.sortDescriptors = [dateDescriptor]
        
        let startDate = Date.dateByMovingToBeginningOfDay()
        let endDate = Date.dateByMovingToEndOfDay()
        let predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@)", startDate, endDate)
        fetchRequest.predicate = predicate
        
        return (fetchCoreDataWithFetchRequest(fetchRequest) as! [History])
    }
    
    
    func fetchCoreDataForWeekActivities() -> [History] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext)
        fetchRequest.entity = entityDescription
        
        let dateDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
        fetchRequest.sortDescriptors = [dateDescriptor]
        
        let startDate = Date.dateSevenDaysAgo()
        let endDate = Date.dateByMovingToEndOfDay()
        let predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@)", startDate, endDate)
        fetchRequest.predicate = predicate
        
        return (fetchCoreDataWithFetchRequest(fetchRequest) as! [History])
    }
    
    func fetchCoreDataForMonthActivities() -> [History] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext)
        fetchRequest.entity = entityDescription
        
        let dateDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
        fetchRequest.sortDescriptors = [dateDescriptor]
        
        let startDate = Date.dateMonthAgo()
        let endDate = Date.dateByMovingToEndOfDay()
        let predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@)", startDate, endDate)
        fetchRequest.predicate = predicate
        
      //  filterResultsMonth("lift")
        
        return (fetchCoreDataWithFetchRequest(fetchRequest) as! [History])
    }
    
    /**
     Fetch core data for all the activities
     - returns: array of Activity objects
     */
    func fetchCoreDataAllActivities() -> [Activity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entityForName("Activity", inManagedObjectContext: self.backgroundManagedObjectContext)
        fetchRequest.entity = entityDescription
        
        let nameDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameDescriptor]
        return (fetchCoreDataWithFetchRequest(fetchRequest) as! [Activity])
    }
    
    /**
     Fetches Core Data with the given fetch request and returns an array with the results if it was successful.
     - parameter fetchRequest: request to make
     - returns: array of objects
     */
    func fetchCoreDataWithFetchRequest(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> [AnyObject]? {
        do {
            let fetchResults = try backgroundManagedObjectContext.executeFetchRequest(fetchRequest)
            return fetchResults
        } catch {
            // error occured
        }
        
        return nil
    }
    
    func filterResultsMonth(_ i: String)-> [History] {
        var activitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataAllActivities()
        // for activity in activitiesArray {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext)
        fetchRequest.entity = entityDescription
        
        let startDate = Date.dateMonthAgo()
        let endDate = Date.dateByMovingToEndOfDay()
        let predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@) AND (name = %@)", startDate, endDate, i)
        fetchRequest.predicate = predicate
        //  fetchRequest.resultType = .DictionaryResultType
        return fetchCoreDataWithFetchRequest(fetchRequest) as! [History]
    }
    
    func filterResultsWeek(_ i: String)-> [History] {
        var activitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataAllActivities()
        // for activity in activitiesArray {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext)
        fetchRequest.entity = entityDescription
        
        let startDate = Date.dateSevenDaysAgo()
        let endDate = Date.dateByMovingToEndOfDay()
        let predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@) AND (name = %@)", startDate, endDate, i)
        fetchRequest.predicate = predicate
        //  fetchRequest.resultType = .DictionaryResultType
        return fetchCoreDataWithFetchRequest(fetchRequest) as! [History]
    }
    
    func filterResultsDay(_ i: String)-> [History] {
        var activitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataAllActivities()
        // for activity in activitiesArray {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext)
        fetchRequest.entity = entityDescription
        
        let startDate = Date.dateByMovingToBeginningOfDay()
        let endDate = Date.dateByMovingToEndOfDay()
        let predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@) AND (name = %@)", startDate, endDate, i)
        fetchRequest.predicate = predicate
        return fetchCoreDataWithFetchRequest(fetchRequest) as! [History]
    }

    
    /**
     Delete a single Core Data object
     - parameter object: object to delete
     */
    func deleteObject(_ object: NSManagedObject) {
        backgroundManagedObjectContext.deleteObject(object)
        saveContext()
    }
    
    /**
     Delete multiple objects
     - parameter objectsToDelete: objects to delete
     */
    func deleteObjects(_ objectsToDelete: [NSManagedObject]) {
        for object in objectsToDelete {
            backgroundManagedObjectContext.deleteObject(object)
        }
        saveContext()
    }
    
}
