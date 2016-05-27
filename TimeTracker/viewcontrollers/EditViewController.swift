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
    var PassDuration: NSNumber!
    var history: History!
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
    let history = fetchController.objectAtIndexPath(indexPath!) as! History
    history.startDate = StartDatePicker.date
    history.endDate = EndDatePicker.date
    cell.timeLabel.text = "\(todayDateFormatter.stringFromDate(history.startDate!)) - \(todayDateFormatter.stringFromDate(history.endDate!))"
   //cell.durationLabel.text = NSString.createDurationStringFromDuration((history.duration?.doubleValue)!)
    cell.durationLabel.text = "00:10"
   // cell.durationLabel.text = timeStringWithTimeToDisplay(10)
    //below creates new instance. then delete current???
    CoreDataHandler.sharedInstance.updateHistory(history.name!, startDate: history.startDate!, endDate: history.endDate!, duration: 0, PassPath: PassPath)
    let historyToDelete = fetchController.objectAtIndexPath(indexPath)
    CoreDataHandler.sharedInstance.deleteObject(historyToDelete as! NSManagedObject)
        tableView.reloadData()
    }
}

        //EDIT: below just adds new instance. could delete old and below should work, so long as update front page?
      // CoreDataHandler.sharedInstance.saveHistory(choosenActivity!.name!, startDate: startDate!, endDate: NSDate(), duration: 90)


        /*
    let predicate = NSPredicate(format: "%activity, %hh:mm - %hh:mm, ", "gym", "10:00", "03:33")
   // let predicate = NSPredicate(format: "objectID == %@", Activity)
    let fetchRequest = NSFetchRequest(entityName: "\(choosenActivity)")
    fetchRequest.predicate = predicate
    do {
        let fetchedEntities = try history.managedObjectContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        fetchedEntities.first?.startDate = history.startDate
        fetchedEntities.first?.endDate = history.endDate
        // ... Update additional properties with new values
    } catch {
        // Do something in response to error condition
    }
    
    do {
        try history.managedObjectContext!.save()
    } catch {
        // Do something in response to error condition
    }
    }
 */