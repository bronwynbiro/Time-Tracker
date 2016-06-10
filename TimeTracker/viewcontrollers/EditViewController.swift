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
   // var PassDate: String!
    var PassCell: UITableViewCell!
    var PassPath: NSIndexPath!
    var tableView: UITableView!
    var startDate: NSDate!
    var endDate: NSDate!
    var PassHistory: History!
    var PassDuration: NSNumber!
    var choosenActivity: Activity?
    var passedSeconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnGetDate(sender: UIButton) {
        // First we need to create a new instance of the NSDateFormatter
        let dateFormatter = NSDateFormatter()
        // Now we specify the display format, e.g. "27-08-2015
        dateFormatter.dateFormat = "hh:mm"
        // Now we get the date from the UIDatePicker and convert it to a string
        let strDate = dateFormatter.stringFromDate(StartDatePicker.date)
        // Finally we set the text of the label to our new string with the date
        if StartDatePicker != nil {
            labelDisplay.text = strDate
        }

    }
    
    @IBAction func btnSetDate(sender: UIButton) {
       let dateFormatter = NSDateFormatter()
         dateFormatter.dateFormat = "hh:mm"
         let strDate = dateFormatter.stringFromDate(StartDatePicker.date)
        //MARK: below works as string literal
        let newDate = NSDate(dateString: strDate)
        StartDatePicker.date = newDate
    }
    
    //EDIT: fix durationLabel and edit existing coredata instead of adding new, and allow it to update on front page
//func updateCellTimes(cell: HistoryCell, indexPath: NSIndexPath) {
@IBAction func updateCellTime(sender: UIButton) {
let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell") as! HistoryCell
    let indexPath = PassPath
    let history = PassHistory
    history.startDate = StartDatePicker.date
    history.endDate = EndDatePicker.date
    cell.timeLabel.text = "\(todayDateFormatter.stringFromDate(history.startDate!)) - \(todayDateFormatter.stringFromDate(history.endDate!))"
    cell.durationLabel.text = NSString.createDurationStringFromDuration((history.duration?.doubleValue)!)
    CoreDataHandler.sharedInstance.updateHistory(history.name!, startDate: history.startDate!, endDate: history.endDate!, duration: 60, PassPath: PassPath, PassHistory: PassHistory)
        tableView.reloadData()
    }
}
