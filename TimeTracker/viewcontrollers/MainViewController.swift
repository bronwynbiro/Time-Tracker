import UIKit
import RealmSwift

let data = dataHandler()
class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var choosenActivity: Activity?
    var isActivityRunning: Bool = false
    var isActivityPaused: Bool = false
    var passedSeconds: Int = 0
    var startDate: Date?
    var quitDate: Date?
    var activityTimer: Timer?
    var totalduration: NSInteger = 0
    var todaysActivitiesArray: [History] = []
    
    lazy var todayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
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
    @IBAction func unwindFromActivitiesView(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! ActivityListViewController
        
        let selectedActivity = sourceViewController.selectedActivity() as Activity
        if choosenActivity != selectedActivity {
            stopActivity()
            choosenActivity = selectedActivity
            startActivity()
        }
    }
    
    /**
     IBAction method to handle the start and pause button's press action.
     TODO: check logic
     */
    @IBAction func startPauseActivity() {
        if isActivityRunning == true {
            pauseActivity()
        } else {
            if isActivityPaused == true {
                isActivityPaused = false
                isActivityRunning = true
                startPauseButton.setTitle("PAUSE", for: UIControlState())
                startActivityTimer()
            } else {
                openActivityView()
            }
        }
        UserDefaults.standard.set(isActivityRunning, forKey:"quitActivityrunning")
        UserDefaults.standard.synchronize()
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
        startPauseButton.setTitle("START", for: UIControlState())
        /*
         //TODO: do we need to save?
        if passedSeconds >= 60 {
            saveActivityToHistory()
        }
         */
        UserDefaults.standard.set(isActivityRunning, forKey:"quitActivityRunning")
        UserDefaults.standard.synchronize()
    }
    
    /**
     Start the new activity. start timer and set properties.
     */
    func startActivity() {
        startDate = Date()
        passedSeconds = 0
        invalidateTimer()
        startActivityTimer()
        startPauseButton.setTitle("PAUSE", for: UIControlState())
        isActivityRunning = true
        isActivityPaused = false
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy, HH:mm"
        
        UserDefaults.standard.set(isActivityRunning, forKey:"quitActivityRunning")
        
        UserDefaults.standard.synchronize()
    }
    
    /**
     Pause the activity.
     */
    func pauseActivity() {
        isActivityPaused = true
        isActivityRunning = false
        invalidateTimer()
        startPauseButton.setTitle("START", for: UIControlState())
        UserDefaults.standard.set(isActivityRunning, forKey:"quitActivityRunning")
        UserDefaults.standard.synchronize()
    }
    
    func startActivityTimer() {
        activityTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MainViewController.updateLabel), userInfo: nil, repeats: true)
    }
    
    /*
     //TODO: not sure if necessary with realm
    func saveActivityToHistory() {
        data.saveHistory(name: choosenActivity!.name!, startDate: startDate! as NSDate, endDate: Date() as NSDate, duration: passedSeconds)
        startDate = nil
        choosenActivity = nil
        passedSeconds = 0
        loadCoreDataEntities()
    }
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
        if isActivityRunning == true {
            let quitActivityRunning = UserDefaults.standard.set(isActivityRunning, forKey:"quitActivityRunning")
            let passedSec = UserDefaults.standard.integer(forKey: "secondsInBackground")
            let quitDate = UserDefaults.standard.object(forKey: "quitDate") as? Date
            if quitDate == nil {
                print("nil quitdate in main")
            }
            print("in app loaded from background.")
            let minutes = (passedSec / 60) % 60
            let hours = (passedSec) / 3600
            minutesLabel.text = NSString.timeStringWithTimeToDisplay(minutes)
            hoursLabel.text = NSString.timeStringWithTimeToDisplay(hours)
            
        }
    }
    
    /**
     If an activity is running save the quit date to be able count the elapsed seconds between going to background and coming back.
     */
    func appGoesIntoBackground() {
        if isActivityRunning == true{
            quitDate = Date()
        }
        UserDefaults.standard.synchronize()
        print("in main view controller appgoesinto.")
    }
    
    
    
    /**
     Update labels every time the timer's method called.
     */
    func updateLabel() {
        passedSeconds += 1
        
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
                sumOfDuration += (history.duration?.intValue)!
            }
        }
        else {
            sumOfDuration = 0
        }
        return sumOfDuration
    }
    
    
    func calculateDeletedDurationForToday(_ historyToSubtract: History?) -> NSInteger {
        let todaysActivitiesArray = data.fetchDataForTodayActivities()
        var totalDuration = calculateTotalDurationForToday()
        if todaysActivitiesArray.count < 1 {
            totalDuration = 0
        }
        else {
            totalDuration = totalDuration - Int(historyToSubtract!.duration!)
        }
        return totalDuration
        
    }
    
    /**
     Called when view has finished loading.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TimeTracker"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "history_icon"), style: .plain, target: self, action: #selector(MainViewController.openHistoryView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "list_icon"), style: .plain, target: self, action: #selector(MainViewController.openActivityView))
        view.backgroundColor = color.pink()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = color.pink()
        tableView.backgroundColor = UIColor.white
    
         let quitActivityRunning = UserDefaults.standard.object(forKey: "quitActivityRunning") as? Bool
         var passedSec = 0
         if quitActivityRunning == true {
            passedSec = UserDefaults.standard.object(forKey: "passedSeconds") as! Int
            print("passed seconds main view did load:", passedSec)
            }

         UserDefaults.standard.synchronize()
         
         var minutes = 0
         var hours = 0
        if (passedSec > 0)  {
            print("reassign minutes hours")
            minutes = (Int(passedSec) / 60) % 60
            hours = (Int(passedSec)) / 3600
        }
         self.minutesLabel.text = NSString.timeStringWithTimeToDisplay(minutes)
         self.hoursLabel.text = NSString.timeStringWithTimeToDisplay(hours)
        
        //updateLabel()
        UserDefaults.standard.synchronize()
    }
    
    /**
     Called when the view appeared. Load the core data entities for today
     - param: animated YES if animated
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCoreDataEntities()
    }
    
    /**
     Opens history view
     */
    func openHistoryView() {
        performSegue(withIdentifier: "showHistory", sender: nil)
    }
    
    /**
     Opens Activity view
     */
    func openActivityView() {
        performSegue(withIdentifier: "showActivities", sender: nil)
    }
    
    /**
     Adds observers for the notifications
     */
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.appGoesIntoBackground), name: NSNotification.Name(rawValue: "ApplicationDidEnterBackground"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.appLoadedFromBackground), name: NSNotification.Name(rawValue: "ApplicationBecameActive"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.applicationWillEnterForeground), name: NSNotification.Name(rawValue: "ApplicationDidEnterForeground"), object: nil)
    }
    
    
    
    /**
     Removes notification observer for this class
     */
    func resetObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     Load history entities from core data.
     */
    func loadCoreDataEntities() {
        var todaysActivitiesArray: Results <History>
        todaysActivitiesArray = data.fetchDataForTodayActivities()
        if todaysActivitiesArray.count > 0 {
            totalduration = calculateTotalDurationForToday()
        }
        tableView.reloadData()
    }
    
    
    // MARK: tableView methods
    /**
     Asks the data source for a cell to insert in a particular location of the table view.
     - parameter tableView: tableView
     - parameter indexPath: indexPath
     - returns: created cell
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! HistoryCell
        if todaysActivitiesArray.count > 0 {
            let history = todaysActivitiesArray[indexPath.row]
            cell.nameLabel.text = "\(history.name!)"
            cell.timeLabel.text = "\(todayDateFormatter.string(from: history.startDate! as Date)) - \(todayDateFormatter.string(from: history.endDate! as Date))"
            cell.durationLabel.text = NSString.createDurationStringFromDuration((history.duration?.doubleValue)!)
        }
        return cell
    }
    
    /**
     How many rows/cells to display
     - parameter tableView: tableView
     - parameter section:   in which section
     - returns: number of rows
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todaysActivitiesArray.count
    }
    
    /**
     Height for each cell
     - parameter tableView: tableView
     - parameter indexPath: at which indexpath
     - returns: height
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    /**
     Height for the headerview
     - parameter tableView: tableView
     - parameter section:   at which section
     - returns: height
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    /**
     What view to use for each section
     - parameter tableView: tableView
     - parameter section:   at which section
     - returns: headerView
     */
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = self.tableView(tableView, titleForHeaderInSection: section)
        let heightForRow = self.tableView(tableView, heightForHeaderInSection: section)
        let headerView = HeaderView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: heightForRow), title: title! as NSString)
        return headerView
    }
    
    /**
     What the title should be
     - parameter tableView: tableView
     - parameter section:   at which section
     - returns: title
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(format: "Total time spent today: \(NSString.createDurationStringFromDuration(Double(totalduration)))")
    }
    
    deinit {
        resetObservers()
    }
}
