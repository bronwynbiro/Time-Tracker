//
//  HistoryViewController.swift
//  TimeTracker
//


import UIKit
import CoreData

/**
    History view controller to display the history objects from core data.
*/

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    /// table view to display items
    @IBOutlet weak var tableView: UITableView!
    /// A label to display when there are no items in the view
    @IBOutlet weak var noItemsLabel: UILabel!

    /// fetch controller
    lazy var fetchController: NSFetchedResultsController = {
        let entity = NSEntityDescription.entityForName("History", inManagedObjectContext: CoreDataHandler.sharedInstance.backgroundManagedObjectContext)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity

        let nameDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [nameDescriptor]

        let fetchedController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataHandler.sharedInstance.backgroundManagedObjectContext, sectionNameKeyPath: "saveTime", cacheName: nil)
        fetchedController.delegate = self
        return fetchedController
    }()

    /// date formatter
    lazy var dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
        }()

    // MARK: view methods
    /**
    Called after the view was loaded, do some initial setup and refresh the view
    */
    override func viewDidLoad() {
        title = "History"

        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorColor = color.pink()
        tableView.backgroundColor = UIColor.whiteColor()

        refreshView()
        loadNormalState()
    }

    /**
        Load the normal state of the navigation bar
    */
    func loadNormalState() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.backBarButtonItem?.action = Selector("backButtonPressed")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("editButtonPressed"))
    }

    /**
        Load the editing state of the navigation bar
    */
    func loadEditState() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete", style: .Plain, target: self, action: Selector("deleteButtonPressed"))

        if numberOfItemsToDelete() == 0 {
            navigationItem.leftBarButtonItem?.enabled = false
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("doneButtonPressed"))
    }

    /**
        Refresh the view, reload the tableView and check if it's needed to show the empty view.
    */
    func refreshView() {
        loadCoreDataEntities()
        checkToShowEmptyLabel()
    }

    /**
        Checks for the available Activities, if YES show the empty view
    */
    func checkToShowEmptyLabel() {
        noItemsLabel.hidden = fetchController.fetchedObjects?.count != 0
        tableView.reloadData()
    }

    /**
        Load history entities from core data.
    */
    func loadCoreDataEntities() {
        do {
            try fetchController.performFetch()
        } catch {
            // error occured while fetching
        }
    }

    /**
        Update the Delete barbutton according to the number of selected objects.
    */
    func updateDeleteButtonTitle() {
        let itemsCountToDelete = numberOfItemsToDelete()
        navigationItem.leftBarButtonItem?.enabled = itemsCountToDelete != 0
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
                let history = fetchController.objectAtIndexPath(indexPath)
                objectsToDelete.append(history as! History)
            }

            CoreDataHandler.sharedInstance.deleteObjects(objectsToDelete)
            checkToShowEmptyLabel()
            updateDeleteButtonTitle()

            if fetchController.fetchedObjects?.count == 0 {
                loadNormalState()
//                loadCoreDataEntities()
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
        navigationController?.popViewControllerAnimated(true)
    }

    // MARK: tableView methods
    /**
    Notifies the receiver that the fetched results controller is about to start processing of one or more changes due to an add, remove, move, or update.

    - parameter controller: controller The fetched results controller that sent the message.
    */
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }

    /**
    Notifies the receiver that a fetched object has been changed due to an add, remove, move, or update. The fetched results controller reports changes to its section before changes to the fetch result objects.

    - parameter controller:   The fetched results controller that sent the message.
    - parameter anObject:     The object that was changed
    - parameter indexPath:    at which indexPath
    - parameter type:         what happened
    - parameter newIndexPath: The destination path for the object for insertions or moves (this value is nil for a deletion).
    */
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case NSFetchedResultsChangeType.Insert:
            tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            break
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Left)
            break
        case .Update:
            configureCell(tableView.cellForRowAtIndexPath(indexPath!) as! HistoryCell, indexPath: indexPath!)
            break
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Left)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
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
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch(type)
        {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            break
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Left)
            break
        case .Update:
            break
        default:
            break
        }
    }

    /**
    Notifies the receiver that the fetched results controller has completed processing of one or more changes due to an add, remove, move, or update.

    - parameter controller: controller The fetched results controller that sent the message.
    */
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

    /**
    Returns the height value for the given indexPath

    - parameter tableView: tableView
    - parameter indexPath: at which indexpath

    - returns: height for a row
    */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }

    /**
    Return the number of rows to display at a given section

    - parameter tableView: tableView
    - parameter section:   at which section

    - returns: number of rows
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
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
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    /**
    Title for the header in a given section

    - parameter tableView: tableView
    - parameter section:   section

    - returns: title of the header
    */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = self.tableView(tableView, titleForHeaderInSection: section)
        let heightForView = self.tableView(tableView, heightForHeaderInSection: section)
        let headerView = HeaderView(frame: CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.frame), heightForView), title: title!)
        return headerView
    }

    /**
    Configures and returns a cell for the given indexpath

    - parameter tableView: tableView
    - parameter indexPath: indexPath

    - returns: cell
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell") as! HistoryCell

        configureCell(cell, indexPath: indexPath)

        return cell
    }

    /**
    Configures a cell at the given indexPath

    - parameter cell:      cell to configure
    - parameter indexPath: indexPath
    */
    func configureCell(cell: HistoryCell, indexPath: NSIndexPath) {
        let history = fetchController.objectAtIndexPath(indexPath) as! History
        if let str = history.name {
            cell.nameLabel.text = history.name
        }
    // MARK: add sidecolor based on selected user color
    // timeLabel doesnt work!
      cell.timeLabel.text = "\(dateFormatter.stringFromDate(history.startDate!)) -  \(dateFormatter.stringFromDate(history.endDate!))"
        cell.durationLabel.text = NSString.createDurationStringFromDuration((history.duration?.doubleValue)!)
        cell.backgroundColor = UIColor.whiteColor()
       // cell.sideColor =
    }

    /**
    Return YES/True to allow editing of cells

    - parameter tableView: tableView
    - parameter indexPath: at which indexPath

    - returns: true if editing allowed
    */
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    /**
    Called when an editing happened to the cell, in this case: delete. So delete the object from core data.

    - parameter tableView:    tableView
    - parameter editingStyle: the editing style, in this case Delete is important
    - parameter indexPath:    at which indexpath
    */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let historyToDelete = fetchController.objectAtIndexPath(indexPath)
            CoreDataHandler.sharedInstance.deleteObject(historyToDelete as! NSManagedObject)
        }
    }

    /**
    Called when user selected a cell, if in editing mode, mark the cell as selected

    - parameter tableView: tableView
    - parameter indexPath: indexPath that was selected
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.editing == true {
            tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
            updateDeleteButtonTitle()
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    /**
    Called when user deselects a cell. If editing, update the delete button's title

    - parameter tableView: tableView
    - parameter indexPath: cell at the indexPath that was deselected
    */
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.editing == true {
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

}


