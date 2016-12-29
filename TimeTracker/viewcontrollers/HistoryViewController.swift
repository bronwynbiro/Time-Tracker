import UIKit
import Foundation
import RealmSwift

extension MainViewController {
    var appDelegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noItemsLabel: UILabel!
    
    
    lazy var todayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter
    }()
    
    var sectionNames: [String] {
        return Set(History.value(forKeyPath: "saveTime") as! [String]).sorted()
    }
    
    lazy var fetchController: RealmResultsController<History, History> = {
        let predicate = NSPredicate(format: "saveTime > 0")
        let nameDescriptor = [SortDescriptor(property: "name"), SortDescriptor(property: "ascending: false")]
        let fetchRequest = RealmRequest<History>(predicate: predicate, realm: realm, sortDescriptors: nameDescriptor)
        let fetchedController = try! RealmResultsController<History, History>(request: fetchRequest, sectionKeyPath: "saveTime")
       // fetchedController.delegate = self
        return fetchedController
    }()
    
    
    // MARK: view methods
    /**
     Called after the view was loaded, do some initial setup and refresh the view
     */
    override func viewDidLoad() {
        title = "History"
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = color.pink()
        tableView.backgroundColor = UIColor.white
        //  suvar.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        refreshView()
        loadNormalState()
    }
    
    /**
     Load the normal state of the navigation bar
     */
    func loadNormalState() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.backBarButtonItem?.action = #selector(HistoryViewController.backButtonPressed)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(HistoryViewController.editButtonPressed))
    }
    
    /**
     Load the editing state of the navigation bar
     */
    func loadEditState() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(HistoryViewController.deleteButtonPressed))
        
        if numberOfItemsToDelete() == 0 {
            navigationItem.leftBarButtonItem?.isEnabled = false
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(HistoryViewController.doneButtonPressed))
    }
    
    /**
     Refresh the view, reload the tableView and check if it's needed to show the empty view.
     */
    func refreshView() {
        //loadDataEntities()
        checkToShowEmptyLabel()
    }
    
    /**
     Checks for the available Activities, if YES show the empty view
     */
    func checkToShowEmptyLabel() {
        let allActivities = realm.objects(Activity.self)
        noItemsLabel.isHidden = allActivities.count != 0
        tableView.reloadData()
    }
    
    /**
     Update the Delete barbutton according to the number of selected objects.
     */
    func updateDeleteButtonTitle() {
        let itemsCountToDelete = numberOfItemsToDelete()
        navigationItem.leftBarButtonItem?.isEnabled = itemsCountToDelete != 0
        navigationItem.leftBarButtonItem?.title = "Delete (\(itemsCountToDelete))"
    }
    
    /**
     Put the tableView into an editing mode and load the editing state
     */
    func editButtonPressed() {
        tableView.setEditing(true, animated: true)
        loadEditState()
    }
    
    /**
     Called when in edit mode the delete is pressed. Delete all the selected rows, if there are any.
     */
    func deleteButtonPressed() {
        let itemsCountToDelete = numberOfItemsToDelete()
        if itemsCountToDelete != 0 {
            var objectsToDelete: [History] = []
            let selectedIndexPaths = tableView.indexPathsForSelectedRows
            for indexPath in selectedIndexPaths! {
                let history = fetchController.object(at: indexPath)
                objectsToDelete.append(history)
            }
            checkToShowEmptyLabel()
            updateDeleteButtonTitle()
            
           // if fetchController.fetchedObjects?.count == 0 {
            let rrc = fetchController
            if rrc.numberOfSections == 0 {
                loadNormalState()
               // loadDataEntities()
            }
        }
    }
    
    /**
     Stop editing of the tableView, and load the normal state
     */
    func doneButtonPressed() {
        tableView.setEditing(false, animated: true)
        loadNormalState()
    }
    
    /**
     Pop the viewController
     */
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
   /*
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    */
    
    func didChangeSection(controller: AnyObject, section: RealmSection<Any>, index: Int, changeType: RealmResultsChangeType) {
        switch changeType {
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: index) as IndexSet, with: UITableViewRowAnimation.automatic)
        case .Insert:
            tableView.insertSections(NSIndexSet(index: index) as IndexSet, with: UITableViewRowAnimation.automatic)
        default:
            break
        }
    }
    func didChangeObject(controller: AnyObject, oldIndexPath: NSIndexPath, newIndexPath: NSIndexPath, changeType: RealmResultsChangeType) {
        switch changeType {
        case .Delete:
            tableView.deleteRows(at: [newIndexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        case .Insert:
            tableView.insertRows(at: [newIndexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        case .Move:
            tableView.deleteRows(at: [oldIndexPath as IndexPath], with: UITableViewRowAnimation.automatic)
            tableView.insertRows(at: [newIndexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        case .Update:
            tableView.reloadRows(at: [newIndexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    /**
   //  Notifies the receiver that the fetched results controller has completed processing of one or more changes due to an add, remove, move, or update.
    // - parameter controller: The fetched results controller that sent the message.
 
    func controllerDidChangeContent(_ controller: RealmResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
   */
    
    /**
     Returns the height value for the given indexPath
     - parameter tableView: tableView
     - parameter indexPath: at which indexpath
     - returns: height for a row
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    // Return the number of rows to display at a given section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = fetchController.numberOfSections
        return sections
        /*
        if sections{
        let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        } else {
            return 0
        }
 */
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchController.numberOfSections
    }
    
    //Height of section header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // Title for the header in a given section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       /*
        let sections = fetchController.sections
        return sections.name
         TODO: ascending: false
 
        let realm = try! Realm()
        let section = realm.objects(History.self).filter("saveTime > 0").sorted(byProperty: "name", ascending: false)
        return section.name
 */
        let items = try! Realm().objects(History.self).sorted(byProperty: "name", ascending: false)
        return sectionNames[section]
    }
    
    
    //Returns a custom header view to be displayed at a section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = self.tableView(tableView, titleForHeaderInSection: section)
        let heightForView = self.tableView(tableView, heightForHeaderInSection: section)
        let headerView = HeaderView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: heightForView), title: title! as NSString)
        return headerView
    }
    
    /**
     Configures and returns a cell for the given indexpath
     - parameter tableView: tableView
     - parameter indexPath: indexPath
     - returns: cell
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    /**
     Configures a cell at the given indexPath
     - parameter cell:      cell to configure
     - parameter indexPath: indexPath
     */
    
    func configureCell(_ cell: HistoryCell, indexPath: IndexPath) -> History {
        let history = fetchController.object(at: indexPath) 
        if history.name != nil {
            cell.nameLabel.text = history.name
        }
        cell.backgroundColor = UIColor.white
       // cell.timeLabel.text = "\(todayDateFormatter.string(from: history.startDate! as Date)) - \(todayDateFormatter.string(from: history.endDate! as Date))"
       // cell.durationLabel.text = NSString.createDurationStringFromDuration((history.duration))
        
        cell.timeLabel.text = "test"
        cell.durationLabel.text = "test"
       // print (todayDateFormatter.string(from: history.startDate! as Date))
        return history
    }
    
    /**
     Return YES/True to allow editing of cells
     - parameter tableView: tableView
     - parameter indexPath: at which indexPath
     - returns: true if editing allowed
     */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /**
     Delete the object from core data.
     - parameter tableView:    tableView
     - parameter editingStyle: the editing style, in this case Delete
     - parameter indexPath:    at which indexpath
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let historyToSubtract = fetchController.object(at: indexPath) 
           MainViewController().calculateDeletedDurationForToday(historyToSubtract)
           
            
            /*
            var historyToDelete = fetchController.objectAtIndexPath(indexPath)
            var todaysActivitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataForTodayActivities()
            var totalDuration = MainViewController().calculateTotalDurationForToday()
            var historyDel = fetchController.objectAtIndexPath(indexPath) as! History
            if todaysActivitiesArray.count < 1 {
                totalDuration = 0
            }
            else {
            totalDuration = totalDuration - Int(historyDel.duration!)
            }
            print(todaysActivitiesArray)
            print(totalDuration)
            CoreDataHandler.sharedInstance.deleteObject(historyToDelete as! NSManagedObject)
           // MainViewController.totalDuration = totalDuration
            CoreDataHandler.sharedInstance.saveContext()
 */
            
        }
    }
    
    /**
     Called when user selected a cell, if in editing mode, mark the cell as selected
     - parameter tableView: tableView
     - parameter indexPath: indexPath that was selected
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing == true {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            updateDeleteButtonTitle()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    /**
     Called when user deselects a cell. If editing, update the delete button's title
     - parameter tableView: tableView
     - parameter indexPath: cell at the indexPath that was deselected
     */
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing == true {
            updateDeleteButtonTitle()
        }
    }
    
    /**
     Returns the number of selected items.
     - returns: number of selected rows.
     */
    func numberOfItemsToDelete() -> NSInteger {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            return selectedRows.count
        } else {
            return 0
        }
    }
    
    func selectedActivity() -> Activity {
        let activitiesArray = DataHandler.sharedInstance.fetchDataAllActivities()
        let selectedIndexPath = tableView.indexPathForSelectedRow!
        return activitiesArray[selectedIndexPath.row]
    }
    
    
    
    //MARK: segue for editview
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView = (segue.destination as! EditViewController)
        let indexPath = tableView.indexPathForSelectedRow
        if (tableView.cellForRow(at: indexPath!) as! HistoryCell!) != nil {
            let history = fetchController.object(at: indexPath!)
            let selectedCell = tableView.cellForRow(at: indexPath!)
            nextView.PassCell = selectedCell
            nextView.PassPath = indexPath
            nextView.PassHistory = fetchController.object(at: indexPath!) 
            nextView.tableView = tableView
            nextView.startDate = history.startDate as Date!
            nextView.endDate = history.endDate as Date!
            nextView.choosenActivity = selectedActivity()
            
        }
}
}
