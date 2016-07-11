//
//  ActivityListViewController.swift
//  TimeTracker
//


import UIKit

 /// View controller that holds all the activities

class ActivityListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewActivityDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noActivitiesLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var activitiesArray: [Activity] = []

    /// custom fadeview to make unavailable to hit an activity while adding new one
    lazy var fadeView: UIView = {
        let fadeView = UIView(frame: self.view.bounds)
        fadeView.backgroundColor = UIColor.blackColor()
        fadeView.alpha = 0.6
        return fadeView
    }()

    /// A custom view to be able to add new activities
    lazy var newActivityView: NewActivityView = {
        let frame = CGRectMake(10.0, -100.0, CGRectGetWidth(self.view.frame)-20.0, 100.0);
        let newActivityView = NewActivityView(frame: frame, delegate: self)
        return newActivityView
    }()

    /**
        Called when finish loading the view, load core data entities
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My activities"
        showNormalNavigationBar()
        view.backgroundColor = UIColor.whiteColor()

        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorColor = UIColor.whiteColor()
        tableView.backgroundColor = UIColor.whiteColor()

        reloadCoreDataEntities()
    }

    /**
        Refresh the view, reload the tableView and check if it's needed to show the empty view.
    */
    func refreshView() {
        tableView.reloadData()
        checkToShowEmptyView()
    }

    /**
        Load activity entities from core data.
    */
    func reloadCoreDataEntities() {
        activitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataAllActivities()
        refreshView()
    }

    /**
        Checks for the available Activities, if YES show the empty view
    */
    func checkToShowEmptyView() {
        noActivitiesLabel.hidden = activitiesArray.count != 0
    }

    /**
        Shows the original navigation bar with back and add buttons
    */
    func showNormalNavigationBar() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.backBarButtonItem?.action = Selector("backButtonPressed")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addNewActivity"))
    }

    /**
        Dismissed the viewController
    */
    func backButtonPressed() {
        navigationController?.popViewControllerAnimated(true)
    }

    /**
        Slide down new activity view and change the barbutton item
    */
    @IBAction func addNewActivity() {
        view.addSubview(newActivityView)
        newActivityView.slideViewDown()
        view.insertSubview(fadeView, belowSubview: newActivityView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("dismissAddview"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self.newActivityView, action: Selector("saveItem"))
    }

    // MARK: tableView methods
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)

    - parameter tableView: tableView
    - parameter section:   at which section

    - returns: number of rows
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitiesArray.count
    }

    /**
    Asks the data source for a cell to insert in a particular location of the table view.

    - parameter tableView: tableView
    - parameter indexPath: at which indexPath

    - returns: configured cell
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!

        let activity = activitiesArray[indexPath.row]
        cell.textLabel?.text = activity.name
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.backgroundColor = UIColor.whiteColor()

        return cell
    }

    /**
    Returns YES, if you are allowed to edit rows

    - parameter tableView: tableView
    - parameter indexPath: at which indexPath

    - returns: YES, if allowed
    */
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    /**
    Handle editing style

    - parameter tableView:    tableView
    - parameter editingStyle: which editing style happened
    - parameter indexPath:    at which cell
    */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let activity = activitiesArray[indexPath.row]
            CoreDataHandler.sharedInstance.deleteObject(activity)
            reloadCoreDataEntities()
        }
    }

    /**
        Tells the delegate that the specified row is now selected. Pass the selected activity to the delegate method.

        - parameter tableView: tableView
        - parameter indexPath: which indexpath was selected
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("unwindFromActivities", sender: indexPath)
    }

    /**
        Returns the selected activity

        - returns: Activity that was selected
    */
    func selectedActivity() -> Activity {
        let selectedIndexPath = tableView.indexPathForSelectedRow!
        return activitiesArray[selectedIndexPath.row]
    }

    /**
        Delegate method, which gets called if activity has been saved.
    */
    func slideActivityViewUp() {
        dismissAddview()
        reloadCoreDataEntities()
    }

    /**
        Dismiss the new activity view and show the original navigation bar
    */
    func dismissAddview() {
        newActivityView.slideViewUp()
        fadeView.removeFromSuperview()
        showNormalNavigationBar()
    }
}
