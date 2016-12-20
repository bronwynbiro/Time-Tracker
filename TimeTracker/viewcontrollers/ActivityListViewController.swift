import UIKit
import RealmSwift

class ActivityListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewActivityDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noActivitiesLabel: UILabel!
    var activitiesArray: [Activity] = []
    @IBOutlet weak var addButton: UIButton!

    /// custom fadeview to make unavailable to hit an activity while adding new one
    lazy var fadeView: UIView = {
        let fadeView = UIView(frame: self.view.bounds)
        fadeView.backgroundColor = UIColor.black
        fadeView.alpha = 0.6
        return fadeView
    }()

    /// A custom view to be able to add new activities
    lazy var newActivityView: NewActivityView = {
        let frame = CGRect(x: 10.0, y: -100.0, width: self.view.frame.width-20.0, height: 100.0);
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
        view.backgroundColor = UIColor.white

        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = UIColor.white
        tableView.backgroundColor = UIColor.white

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
        noActivitiesLabel.isHidden = activitiesArray.count != 0
    }

    /**
        Shows the original navigation bar with back and add buttons
    */
    func showNormalNavigationBar() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.backBarButtonItem?.action = #selector(ActivityListViewController.backButtonPressed)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(ActivityListViewController.addNewActivity))
    }

    /**
        Dismissed the viewController
    */
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    /**
        Slide down new activity view and change the barbutton item
    */
    @IBAction func addNewActivity() {
        view.addSubview(newActivityView)
        newActivityView.slideViewDown()
        view.insertSubview(fadeView, belowSubview: newActivityView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ActivityListViewController.dismissAddview))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self.newActivityView, action: Selector("saveItem"))
    }

    // MARK: tableView methods
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)

    - parameter tableView: tableView
    - parameter section:   at which section

    - returns: number of rows
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitiesArray.count
    }

    /**
    Asks the data source for a cell to insert in a particular location of the table view.

    - parameter tableView: tableView
    - parameter indexPath: at which indexPath

    - returns: configured cell
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!

        let activity = activitiesArray[indexPath.row]
        cell.textLabel?.text = activity.name
        cell.textLabel?.textColor = UIColor.black
        cell.backgroundColor = UIColor.white

        return cell
    }

    /**
    Returns YES, if you are allowed to edit rows

    - parameter tableView: tableView
    - parameter indexPath: at which indexPath

    - returns: YES, if allowed
    */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    /**
    Handle editing style

    - parameter tableView:    tableView
    - parameter editingStyle: which editing style happened
    - parameter indexPath:    at which cell
    */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "unwindFromActivities", sender: indexPath)
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
