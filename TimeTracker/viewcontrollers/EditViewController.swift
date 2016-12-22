import UIKit
import CoreData
import Foundation

extension Date
{
    
    init(dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "hh:mm"
        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
        //MARK: switch to date from old??
        let d = dateStringFormatter.date(from: dateString)!
        (self as NSDate).init(timeInterval:0, since:d)
    }
}
/*
var fetchController: NSFetchedResultsController = {
    let entity = NSEntityDescription.entityForName("History", inManagedObjectContext: CoreDataHandler.sharedInstance.backgroundManagedObjectContext)
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    fetchRequest.entity = entity
    
    let nameDescriptor = NSSortDescriptor(key: "name", ascending: false)
    fetchRequest.sortDescriptors = [nameDescriptor]
    
    let fetchedController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataHandler.sharedInstance.backgroundManagedObjectContext, sectionNameKeyPath: "saveTime", cacheName: nil)
    //fetchedController.delegate = self
    return fetchedController
}()
 */

var todayDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter
}()

class EditViewController: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var EndDatePicker: UIDatePicker!
    @IBOutlet weak var StartDatePicker: UIDatePicker!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var labelDisplay: UITextField!
    
    var PassCell: UITableViewCell!
    var PassPath: IndexPath!
    var tableView: UITableView!
    var startDate: Date!
    var endDate: Date!
    var PassHistory: History!
    var PassDuration: NSNumber!
    var choosenActivity: Activity?
    var passedSeconds: Int = 0
    var startDateYear: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StartDatePicker.date = PassHistory.startDate! as Date
        EndDatePicker.date =  PassHistory.endDate! as Date
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateCellTime(_ sender: UIButton) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        let indexPath = PassPath
        let history = PassHistory
        history?.startDate = StartDatePicker.date
        history?.endDate = EndDatePicker.date
        cell.timeLabel.text = "\(todayDateFormatter.string(from: history?.startDate! as! Date)) - \(todayDateFormatter.string(from: history?.endDate! as! Date))"
        let PassDuration = history?.endDate!.timeIntervalSince(history?.startDate! as! Date!)
        cell.durationLabel.text = NSString.createDurationStringFromDuration((PassDuration))
        CoreDataHandler.sharedInstance.updateHistory(history.name!, startDate: history.startDate!, endDate: history.endDate!, duration: Int(PassDuration), PassPath: PassPath, PassHistory: PassHistory)
        
        tableView.reloadData()
    }
}
