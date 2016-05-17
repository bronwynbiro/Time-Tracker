//
//  EditViewController.swift
//  TimeTracker
//

import UIKit
import CoreData
import Foundation

class EditViewController: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
//@IBOutlet weak var EndDatePicker: UIDatePicker!
    @IBOutlet weak var lblDisplayDate: UITextField!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var StartDatePicker: UIDatePicker!
    @IBOutlet weak var EndDatePicker: UIDatePicker!
    
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
        lblDisplayDate.text = strDate
    }
    
    @IBAction func btnSetDate(sender: UIButton) {
        let newDate = NSDate(dateString:"10-33")
        StartDatePicker.date = newDate
    }
}

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
    

//MARK: trying to fix start dates and allow editing
/*
func updateCellTimes(cell: HistoryCell, indexPath: NSIndexPath) {
let history = fetchController.objectAtIndexPath(indexPath) as! History
if let str = history.name {
cell.nameLabel.text = history.name

var historyDateFormatter: NSDateFormatter = {
let dateFormatter = NSDateFormatter()
dateFormatter.dateFormat = "hh:mm"
return dateFormatter
}()
}
*/
    