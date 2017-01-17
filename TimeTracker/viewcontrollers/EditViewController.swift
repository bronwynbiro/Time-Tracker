import UIKit
import RealmSwift
import Foundation

extension Date {
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

let allActivitiesArray = DataHandler.sharedInstance.fetchDataAllActivities()
let activities = Array(allActivitiesArray!)
var pickerDataSource = activities


class EditViewController: UIViewController, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var EndDatePicker: UIDatePicker!
    @IBOutlet weak var StartDatePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
   // @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var labelDisplay: UITextField!
    
    var PassCell: UITableViewCell!
    var PassPath: IndexPath!
    var tableView: UITableView!
    var startDate: Date!
    var endDate: Date!
    var PassHistory = History()
    var PassDuration: Double!
    var choosenActivity: Activity?
    var passedSeconds: Int = 0
    var startDateYear: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StartDatePicker.date = PassHistory.startDate! as Date
        EndDatePicker.date =  PassHistory.endDate! as Date
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        //return pickerDataSource[row]
        return "nugger"
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        labelDisplay.text = "test"
            //pickerDataSource[row]
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
        DataHandler.sharedInstance.updateHistory(name: history.name!, startDate: history.startDate! as NSDate, endDate: history.endDate! as NSDate, duration: Int(PassDuration), PassPath: PassPath as NSIndexPath, PassHistory: PassHistory)
        tableView.reloadData()
    }
}
