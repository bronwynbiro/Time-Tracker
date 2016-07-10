//
//  EditViewController.swift
//  TimeTracker
//

import UIKit
import CoreData
import Foundation

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "hh:mm"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        //MARK: switch to date from old??
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}
var fetchController: NSFetchedResultsController = {
    let entity = NSEntityDescription.entityForName("History", inManagedObjectContext: CoreDataHandler.sharedInstance.backgroundManagedObjectContext)
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = entity
    
    let nameDescriptor = NSSortDescriptor(key: "name", ascending: false)
    fetchRequest.sortDescriptors = [nameDescriptor]
    
    let fetchedController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataHandler.sharedInstance.backgroundManagedObjectContext, sectionNameKeyPath: "saveTime", cacheName: nil)
    //fetchedController.delegate = self
    return fetchedController
}()

/// date formatter
var todayDateFormatter: NSDateFormatter = {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter
}()

class EditViewController: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var EndDatePicker: UIDatePicker!
    @IBOutlet weak var StartDatePicker: UIDatePicker!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var labelDisplay: UITextField!
    
    var PassCell: UITableViewCell!
    var PassPath: NSIndexPath!
    var tableView: UITableView!
    var startDate: NSDate!
    var endDate: NSDate!
    var PassHistory: History!
    var PassDuration: NSNumber!
    var choosenActivity: Activity?
    var passedSeconds: Int = 0
    var startDateYear: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StartDatePicker.date = PassHistory.startDate!
        EndDatePicker.date =  PassHistory.endDate!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateCellTime(sender: UIButton) {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell") as! HistoryCell
        let indexPath = PassPath
        let history = PassHistory
        history.startDate = StartDatePicker.date
        history.endDate = EndDatePicker.date
        cell.timeLabel.text = "\(todayDateFormatter.stringFromDate(history.startDate!)) - \(todayDateFormatter.stringFromDate(history.endDate!))"
        var PassDuration = history.endDate!.timeIntervalSinceDate(history.startDate!)
        cell.durationLabel.text = NSString.createDurationStringFromDuration((PassDuration))
        CoreDataHandler.sharedInstance.updateHistory(history.name!, startDate: history.startDate!, endDate: history.endDate!, duration: Int(PassDuration), PassPath: PassPath, PassHistory: PassHistory)
        
        tableView.reloadData()
    }
}