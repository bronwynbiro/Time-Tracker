//
//  MainViewController.swift
//  TimeTracker
//


import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /// the choosen activity object to use
    var choosenActivity: Activity?
    
    /// boolean value to determine whether an activity is running
    var isActivityRunning: Bool = false
    /// boolean value to determine whether an activity is paused
    var isActivityPaused: Bool = false
    /// passed seconds from start
    var passedSeconds: Int = 0
    
    /// date of start
    var startDate: NSDate?
    /// date of quitting the app
    var quitDate: NSDate?
    
    /// timer that counts the seconds
    var activityTimer: NSTimer?
    /// total number of seconds for history objects
    var totalduration: NSInteger = 0
    
    /// array of all the activities (history objects) that happened today
    var todaysActivitiesArray: [History] = []
    
    /// today's date formatter
    lazy var todayDateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    
    /**
     Called when user selected an activity on ActivityListViewController. First it checks to see if any activities are running, if YES it stops the current one, and runs the new
     - parameter unwindSegue: the unwind segue
     */
    @IBAction func unwindFromActivitiesView(unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.sourceViewController as! ActivityListViewController
        
        let selectedActivity = sourceViewController.selectedActivity()
        if choosenActivity != selectedActivity {
            stopActivity()
            choosenActivity = selectedActivity
            startActivity()
        }
    }
    
    /**
     IBAction method to handle the start and pause button's press action.
     */
    @IBAction func startPauseActivity() {
        if isActivityRunning == true {
            pauseActivity()
        } else {
            if isActivityPaused == true {
                isActivityPaused = false
                isActivityRunning = true
                startPauseButton.setTitle("PAUSE", forState: .Normal)
                startActivityTimer()
            } else {
                openActivityView()
            }
        }
    }
    
    /**
     Stop the activity and save it to core data.
     */
    @IBAction func stopActivity() {
        invalidateTimer()
        isActivityRunning = false
        isActivityPaused = false
        minutesLabel.text = "00"
        hoursLabel.text = "00"
        activityLabel.text = "START"
        startPauseButton.setTitle("START", forState: .Normal)
        if passedSeconds >= 60 {
            saveActivityToHistory()
        }
    }
    
    /**
     Start the new activity. start timer and set properties.
     */
    func startActivity() {
        startDate = NSDate()
        passedSeconds = 0
        invalidateTimer()
        startActivityTimer()
        startPauseButton.setTitle("PAUSE", forState: .Normal)
        isActivityRunning = true
        isActivityPaused = false
        
        //EDIt
        let dateFormatter = NSDateFormatter()
        //the "M/d/yy, H:mm" is put together from the Symbol Table
        dateFormatter.dateFormat = "MM/dd/yyyy, HH:mm"
        print(dateFormatter.stringFromDate(startDate!))
    }
    
    /**
     Pause the activity.
     */
    func pauseActivity() {
        isActivityPaused = true
        isActivityRunning = false
        invalidateTimer()
        startPauseButton.setTitle("START", forState: .Normal)
    }
    
    func startActivityTimer() {
        activityTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateLabel"), userInfo: nil, repeats: true)
    }
    
    /**
     Save the finished activity to core data as a history object.
     */
    func saveActivityToHistory() {
        CoreDataHandler.sharedInstance.saveHistory(choosenActivity!.name!, startDate: startDate!, endDate: NSDate(), duration: passedSeconds)
        
        passedSeconds = 0
        loadCoreDataEntities()
    }
    
    /**
     Invalidate the timer
     */
    func invalidateTimer() {
        if let timer = activityTimer {
            timer.invalidate()
        }
    }
    
    /**
     If an activity is running save the return date to be able count the elapsed seconds between going to background and coming back. And count the passed seconds.
     */
    func appLoadedFromBackground() {
        if isActivityPaused == false {
            let passedSecondsTillInactive = NSDate().timeIntervalSinceDate(quitDate!)
            passedSeconds += Int(passedSecondsTillInactive)
        }
    }
    
    /**
     If an activity is running save the quit date to be able count the elapsed seconds between going to background and coming back.
     */
    func appGoesIntoBackground() {
        if isActivityPaused == false {
            quitDate = NSDate()
        }
    }
    
    /**
     Update labels every time the timer's method called.
     */
    func updateLabel() {
        passedSeconds++
        
        let minutes = (passedSeconds / 60) % 60
        let hours = passedSeconds / 3600
        
        minutesLabel.text = NSString.timeStringWithTimeToDisplay(minutes)
        hoursLabel.text = NSString.timeStringWithTimeToDisplay(hours)
    }
    
    /**
     Calculate the total duration of activites for today.
     - returns: NSInteger summary value of durations as an integer.
     */
    func calculateTotalDurationForToday() -> NSInteger {
        var sumOfDuration = 0
        if todaysActivitiesArray.count > 0 {
        for history in todaysActivitiesArray {
            sumOfDuration += (history.duration?.integerValue)!
            }
        }
        else {
            sumOfDuration = 0
        }
        return sumOfDuration
    }
    
    func calculateDeletedDurationForToday(historyToSubtract: History?) -> NSInteger {
        var todaysActivitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataForTodayActivities()
        var totalDuration = calculateTotalDurationForToday()
        if todaysActivitiesArray.count < 1 {
            totalDuration = 0
        }
        else {
            totalDuration = totalDuration - Int(historyToSubtract!.duration!)
        }
        print(todaysActivitiesArray)
        print(totalDuration)
        CoreDataHandler.sharedInstance.deleteObject(historyToSubtract as! NSManagedObject)
        CoreDataHandler.sharedInstance.saveContext()
        
        return totalDuration
        
    }
    
    /**
     Called when view has finished loading.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TimeTracker"
        //MARK": change items to be different colors
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "history_icon"), style: .Plain, target: self, action: Selector("openHistoryView"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "list_icon"), style: .Plain, target: self, action: Selector("openActivityView"))
        
        view.backgroundColor = color.pink()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorColor = color.pink()
        tableView.backgroundColor = UIColor.whiteColor()
        
        addObservers()
    }
    
    /**
     Called when the view appeared. Load the core data entities for today
     - param: animated YES if animated
     */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadCoreDataEntities()
    }
    
    /**
     Opens history view
     */
    func openHistoryView() {
        performSegueWithIdentifier("showHistory", sender: nil)
    }
    
    /**
     Opens Activity view
     */
    func openActivityView() {
        performSegueWithIdentifier("showActivities", sender: nil)
    }
    
    /**
     Adds observers for the notifications
     */
    func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("appGoesIntoBackground"), name: "AppDidEnterBackground", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("appLoadedFromBackground"), name: "AppBecameActive", object: nil)
    }
    
    /**
     Removes notification observer for this class
     */
    func resetObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     Load history entities from core data.
     */
    func loadCoreDataEntities() {
        todaysActivitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataForTodayActivities()
        if todaysActivitiesArray.count > 0 {
            totalduration = calculateTotalDurationForToday()
        }
        tableView.reloadData()
        print(todaysActivitiesArray)
    }
    
    lazy var fetchController: NSFetchedResultsController = {
        let entity = NSEntityDescription.entityForName("History", inManagedObjectContext: CoreDataHandler.sharedInstance.backgroundManagedObjectContext)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        let nameDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [nameDescriptor]
        
        let fetchedController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataHandler.sharedInstance.backgroundManagedObjectContext, sectionNameKeyPath: "saveTime", cacheName: nil)
        return fetchedController
    }()

    
    
    // MARK: tableView methods
    /**
     Asks the data source for a cell to insert in a particular location of the table view.
     - parameter tableView: tableView
     - parameter indexPath: indexPath
     - returns: created cell
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! HistoryCell
        if todaysActivitiesArray.count > 0 {
        var history = todaysActivitiesArray[indexPath.row]
        print(todaysActivitiesArray)
            print(history)
        cell.nameLabel.text = "\(history.name!)"
        cell.timeLabel.text = "\(todayDateFormatter.stringFromDate(history.startDate!)) - \(todayDateFormatter.stringFromDate(history.endDate!))"
        cell.durationLabel.text = NSString.createDurationStringFromDuration((history.duration?.doubleValue)!)
       // history.nsmanagedobjectcontextobjectsdidchangenotification
       // NSObject.didchange
        }
        return cell
    }
    
    /**
     How many rows/cells to display
     - parameter tableView: tableView
     - parameter section:   in which section
     - returns: number of rows
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todaysActivitiesArray.count
    }
    
    /**
     Height for each cell
     - parameter tableView: tableView
     - parameter indexPath: at which indexpath
     - returns: height
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
    /**
     Height for the headerview
     - parameter tableView: tableView
     - parameter section:   at which section
     - returns: height
     */
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    /**
     What view to use for each section
     - parameter tableView: tableView
     - parameter section:   at which section
     - returns: headerView
     */
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = self.tableView(tableView, titleForHeaderInSection: section)
        let heightForRow = self.tableView(tableView, heightForHeaderInSection: section)
        let headerView = HeaderView(frame: CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.frame), heightForRow), title: title!)
        return headerView
    }
    
    /**
     What the title should be
     - parameter tableView: tableView
     - parameter section:   at which section
     - returns: title
     */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(format: "Total time spent today: \(NSString.createDurationStringFromDuration(Double(totalduration)))")
    }
    
    deinit {
        resetObservers()
    }
}