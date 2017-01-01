import UIKit
import RealmSwift
import Foundation

extension Date
{
    
    init(dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "hh:mm"
        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
        let d = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:d)
    }
}

var todayDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter
}()


class EditViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var EndDatePicker: UIDatePicker!
    @IBOutlet weak var StartDatePicker: UIDatePicker!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var labelDisplay: UITextField!
    
    var PassCell: UITableViewCell!
    var PassPath: IndexPath!
    var tableView: UITableView!
    var startDate: Date!
    var endDate: Date!
    /*
    var PassHistory: History!
    var PassDuration: NSNumber!
 */
    var PassHistory = History()
    var PassDuration: Double!
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
        let history = PassHistory
        let realm = try! Realm()
        try! realm.write {
            realm.add(history)
            history.startDate = StartDatePicker.date as NSDate?
            history.endDate = EndDatePicker.date as NSDate?
            history.duration = history.endDate!.timeIntervalSince(history.startDate! as Date!)
        }
        cell.timeLabel.text = "\(todayDateFormatter.string(from: history.startDate! as Date )) - \(todayDateFormatter.string(from: history.endDate! as Date))"
        let PassDuration = history.endDate!.timeIntervalSince(history.startDate! as Date!)
       cell.durationLabel.text = NSString.createDurationStringFromDuration((PassDuration))
        //Is this needed?"
        //data.updateHistory(name: history!.name!, startDate: history!.startDate! as NSDate, endDate: history!.endDate! as NSDate, duration: Int(PassDuration!), PassPath: PassPath as NSIndexPath, PassHistory: PassHistory)
        
        tableView.reloadData()
    }
}
