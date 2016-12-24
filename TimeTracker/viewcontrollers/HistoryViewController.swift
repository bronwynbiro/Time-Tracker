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
                objectsToDelete.append(history as! History)
            }
            checkToShowEmptyLabel()
            updateDeleteButtonTitle()
            
            if fetchController.fetchedObjects?.count == 0 {
                loadNormalState()
                loadCoreDataEntities()
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
    
    // MARK: tableView methods
    //Notifies the receiver that the fetched results controller is about to start processing of one or more changes due to an add, remove, move, or update.
    //parameter controller: controller The fetched results controller that sent the message.
/*
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    */
    
    /**
     Notifies the receiver that a fetched object has been changed due to an add, remove, move, or update. The fetched results controller reports changes to its section before changes to the fetch result objects.
     - parameter controller:   The fetched results controller that sent the message.
     - parameter anObject:     The object that was changed
     - parameter indexPath:    at which indexPath
     - parameter type:         what happened
     - parameter newIndexPath: The destination path for the object for insertions or moves (this value is nil for a deletion).
     */
    func controller(_ controller: RealmResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: RealmResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case NSFetchedResultsChangeType.insert:
            tableView.insertRows(at: [indexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .left)
            break
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!) as! HistoryCell, indexPath: indexPath!)
            break
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .left)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        }
    }
    
    /**
     Notifies the receiver of the addition or removal of a section. The fetched results controller reports changes to its section before changes to the fetched result objects.
     - parameter controller:   The fetched results controller that sent the message.
     - parameter sectionInfo:  section that was changed
     - parameter sectionIndex: the index of the section
     - parameter type:         what happened
     */
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch(type)
        {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            break
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .left)
            break
        case .update:
            break
        default:
            break
        }
    }
    
    /**
     Notifies the receiver that the fetched results controller has completed processing of one or more changes due to an add, remove, move, or update.
     - parameter controller: The fetched results controller that sent the message.
     */
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    /**
     Returns the height value for the given indexPath
     - parameter tableView: tableView
     - parameter indexPath: at which indexpath
     - returns: height for a row
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    /**
     Return the number of rows to display at a given section
     - parameter tableView: tableView
     - parameter section:   at which section
     - returns: number of rows
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        } else {
            return 0
        }
    }
    
    /**
     Returns the number of sections to display
     - parameter tableView: tableView
     - returns: number of sections to display
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchController.sections {
            return sections.count
        } else {
            return 0
        }
    }
    
    /**
     Asks the delegate for the height to use for the header of a particular section.
     - parameter tableView: tableView
     - parameter section:   section
     - returns: height of a header
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    /**
     Title for the header in a given section
     - parameter tableView: tableView
     - parameter section:   section
     - returns: title of the header
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchController.sections {
            return sections[section].name
        } else {
            return ""
        }
    }
    
    /**
     Returns a custom header view to be displayed at a section
     - parameter tableView: tableView
     - parameter section:   section
     - returns: headerView
     */
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
        let history = fetchController.object(at: indexPath) as! History
        if let str = history.name {
            cell.nameLabel.text = history.name
        }
        cell.backgroundColor = UIColor.white
        cell.timeLabel.text = "\(todayDateFormatter.string(from: history.startDate!)) - \(todayDateFormatter.string(from: history.endDate!))"
        cell.durationLabel.text = NSString.createDurationStringFromDuration((history.duration?.doubleValue)!)
        print (todayDateFormatter.string(from: history.startDate!))
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
            let historyToSubtract = fetchController.object(at: indexPath) as! History
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
        let activitiesArray = data.fetchDataAllActivities()
        let selectedIndexPath = tableView.indexPathForSelectedRow!
        return activitiesArray[selectedIndexPath.row]
    }
    
    
    
    //MARK: segue for editview
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView = (segue.destination as! EditViewController)
        // Get the cell that generated this segue.
        let indexPath = tableView.indexPathForSelectedRow
        if let currentCell = tableView.cellForRow(at: indexPath!) as! HistoryCell! {
            let history = fetchController.object(at: indexPath!)
            let selectedCell = tableView.cellForRow(at: indexPath!)
            nextView.PassCell = selectedCell
            nextView.PassPath = indexPath
            nextView.PassHistory = fetchController.object(at: indexPath!) as! History
            nextView.tableView = tableView
            nextView.startDate = history.startDate
            nextView.endDate = history.endDate
            nextView.choosenActivity = selectedActivity()
            
        }
}
}
