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
       // let newDate = NSDate(dateString: "10:30")
        let newDate = NSDate(dateString: strDate)
        StartDatePicker.date = newDate
}
}


func updateCellTimes(cell: HistoryCell, indexPath: NSIndexPath) {
 let history = fetchController.objectAtIndexPath(indexPath) as! History
    let userCalendar = NSCalendar.currentCalendar()
    let testComponents = NSDateComponents()
    testComponents.year = 2016
    testComponents.month = 5
    testComponents.day = 21
    let test = userCalendar.dateFromComponents(testComponents)!
 if let str = history.name {
 cell.nameLabel.text = history.name
    //placeholder
    history.startDate = test
    cell.timeLabel.text = "\(todayDateFormatter.stringFromDate(test))"
}
}
func loadCoreDataEntities() {
    do {
        try fetchController.performFetch()
    } catch {
        // error occured while fetching
    }
}

func refreshView() {
    loadCoreDataEntities()
   // tableView.reloadData()
}




