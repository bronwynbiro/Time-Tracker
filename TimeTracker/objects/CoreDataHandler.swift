//
//  CoreDataHandler.swift
//  TimeTracker
//


import UIKit
import CoreData

class CoreDataHandler: NSObject {
    
    /**
     Creates a singleton object to be used across the whole app easier
     - returns: CoreDataHandler
     */
    class var sharedInstance: CoreDataHandler {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: CoreDataHandler? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = CoreDataHandler()
        }
        return Static.instance!
    }
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    
    lazy var backgroundManagedObjectContext: NSManagedObjectContext = {
        let backgroundManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        let coordinator = self.persistentStoreCoordinator
        backgroundManagedObjectContext.persistentStoreCoordinator = coordinator
        return backgroundManagedObjectContext
    }()
    
    lazy var objectModel: NSManagedObjectModel = {
        let modelPath = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")
        let objectModel = NSManagedObjectModel(contentsOfURL: modelPath!)
        return objectModel!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.objectModel)
        
        // Get the paths to the SQLite file
        let storeURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent("Model.sqlite")
        
        // Define the Core Data version migration options
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        
        // Attempt to load the persistent store
        var error: NSError?
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
           
        }
        return persistentStoreCoordinator
    }()
    
    func applicationDocumentsDirectory() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
    }
    
    func saveContext() {
        do {
            try backgroundManagedObjectContext.save()
        } catch {
            
        }
    }
    
    /**
     Tells whether the passed in activity's name is already saved or not.
     - parameter activityName: activityName activity to be saved.
     - returns: BOOL boolean value determining whether the activity is already in core data or not.
     */
    func isDuplicate(activityName: String) -> Bool {
        let entityDescription = NSEntityDescription.entityForName("Activity", inManagedObjectContext: self.backgroundManagedObjectContext)
        let request = NSFetchRequest()
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
    lazy var dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()
    
    /**
     Adds new activity to core data.
     - parameter name: name activity name to be saved.
     */
    func addNewActivityName(name: String) {
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
    func saveHistory(name: String, startDate: NSDate, endDate: NSDate, duration: NSInteger) {
        let history: History = NSEntityDescription.insertNewObjectForEntityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext) as! History
        history.name = name
        history.startDate = startDate
        history.endDate = endDate
        history.duration = duration
        history.saveTime = dateFormatter.stringFromDate(endDate)
        saveContext()
    }
    
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
        history.startDate = startDate
        history.endDate = endDate
        //calculate new duration
        let calendar = NSCalendar.currentCalendar()
        let dateMakerFormatter = NSDateFormatter()
        dateMakerFormatter.dateFormat = "hh:mm a"
        let startTime = startDate
        let endTime = endDate
        let hourMinuteComponents: NSCalendarUnit = [.Hour, .Minute]
        let timeDifference = calendar.components(
            hourMinuteComponents,
            fromDate: startTime,
            toDate: endTime,
            options: [])
        let durationString = "\(timeDifference)"
        let interval = endDate.timeIntervalSinceDate(startDate)
        history.duration = interval
        history.saveTime = dateFormatter.stringFromDate(endDate)
        saveContext()
    }
    
    
    /**
     Fetch core data to get all history objects.
     - returns: array of history objects
     */
    func allHistoryItems() -> [History]? {
        let fetchRequest = NSFetchRequest()
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
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext)
        fetchRequest.entity = entityDescription
        
        let dateDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
        fetchRequest.sortDescriptors = [dateDescriptor]
        
        let startDate = NSDate.dateByMovingToBeginningOfDay()
        let endDate = NSDate.dateByMovingToEndOfDay()
        let predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@)", startDate, endDate)
        fetchRequest.predicate = predicate
        
        return (fetchCoreDataWithFetchRequest(fetchRequest) as! [History])
    }
    
    
    func fetchCoreDataForWeekActivities() -> [History] {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext)
        fetchRequest.entity = entityDescription
        
        let dateDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
        fetchRequest.sortDescriptors = [dateDescriptor]
        
        let startDate = NSDate.dateSevenDaysAgo()
        let endDate = NSDate.dateByMovingToEndOfDay()
        let predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@)", startDate, endDate)
        fetchRequest.predicate = predicate
        
        return (fetchCoreDataWithFetchRequest(fetchRequest) as! [History])
    }
    
    func fetchCoreDataForMonthActivities() -> [History] {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext)
        fetchRequest.entity = entityDescription
        
        let dateDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
        fetchRequest.sortDescriptors = [dateDescriptor]
        
        let startDate = NSDate.dateMonthAgo()
        let endDate = NSDate.dateByMovingToEndOfDay()
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
        let fetchRequest = NSFetchRequest()
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
    func fetchCoreDataWithFetchRequest(fetchRequest: NSFetchRequest) -> [AnyObject]? {
        do {
            let fetchResults = try backgroundManagedObjectContext.executeFetchRequest(fetchRequest)
            return fetchResults
        } catch {
            // error occured
        }
        
        return nil
    }
    
    func filterResultsMonth(i: String)-> [History] {
        var activitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataAllActivities()
        // for activity in activitiesArray {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext)
        fetchRequest.entity = entityDescription
        
        let startDate = NSDate.dateMonthAgo()
        let endDate = NSDate.dateByMovingToEndOfDay()
        let predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@) AND (name = %@)", startDate, endDate, i)
        fetchRequest.predicate = predicate
        //  fetchRequest.resultType = .DictionaryResultType
        return fetchCoreDataWithFetchRequest(fetchRequest) as! [History]
    }
    
    func filterResultsWeek(i: String)-> [History] {
        var activitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataAllActivities()
        // for activity in activitiesArray {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext)
        fetchRequest.entity = entityDescription
        
        let startDate = NSDate.dateSevenDaysAgo()
        let endDate = NSDate.dateByMovingToEndOfDay()
        let predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@) AND (name = %@)", startDate, endDate, i)
        fetchRequest.predicate = predicate
        //  fetchRequest.resultType = .DictionaryResultType
        return fetchCoreDataWithFetchRequest(fetchRequest) as! [History]
    }
    
    func filterResultsDay(i: String)-> [History] {
        var activitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataAllActivities()
        // for activity in activitiesArray {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("History", inManagedObjectContext: self.backgroundManagedObjectContext)
        fetchRequest.entity = entityDescription
        
        let startDate = NSDate.dateByMovingToBeginningOfDay()
        let endDate = NSDate.dateByMovingToEndOfDay()
        let predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@) AND (name = %@)", startDate, endDate, i)
        fetchRequest.predicate = predicate
        return fetchCoreDataWithFetchRequest(fetchRequest) as! [History]
    }

    
    /**
     Delete a single Core Data object
     - parameter object: object to delete
     */
    func deleteObject(object: NSManagedObject) {
        backgroundManagedObjectContext.deleteObject(object)
        saveContext()
    }
    
    /**
     Delete multiple objects
     - parameter objectsToDelete: objects to delete
     */
    func deleteObjects(objectsToDelete: [NSManagedObject]) {
        for object in objectsToDelete {
            backgroundManagedObjectContext.deleteObject(object)
        }
        saveContext()
    }
    
}