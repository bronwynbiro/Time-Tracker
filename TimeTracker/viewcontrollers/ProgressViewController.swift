import UIKit
import Foundation
import RealmSwift
import Charts

class progressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var numberOfRows = ["test1"]
    var percentArray = [Double]()
    var orderedNamesArray = [String]()
    @IBOutlet weak var pieChartView: PieChartView!
    

    
    override func viewDidLoad() {
        title = "Progress"
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = color.pink()
        tableView.backgroundColor = UIColor.white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        loadNormalState()
        tableView.reloadData()
    }
    
    func loadNormalState() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.backBarButtonItem?.action = Selector(("backButtonPressed"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: Selector(("editButtonPressed")))
    }
    

    
    @IBAction func calculateTodaysActivities(_ sender: UIButton) {
        percentArray.removeAll()
        orderedNamesArray.removeAll()
        let todaysActivitiesArray = data.fetchDataForTodayActivities()
        numberOfRows.removeAll()
        self.tableView.reloadData()
        var sumOfDay: Double = 0
        if todaysActivitiesArray.count > 0 {
            for history in todaysActivitiesArray {
                sumOfDay += (history.duration)
            }
        }
        var namesArray = [String]()
        for histname in todaysActivitiesArray{
            namesArray.insert(histname.name!, at: 0)
        }
        
        let unique = Array(Set(namesArray))
        
        var sum: Double = 0
        var percentage: Double = 0
        var nameString: String = " "
        
        for i in unique.indices{
            let activArr = DataHandler.filterResultsDay(i: unique[i])
            let uniqueActivArr = Array(Set(activArr))
            sum = 0
            for myObj in uniqueActivArr {
                let testPath = NSIndexPath(row: i, section: 0)
                let cell = tableView.cellForRow(at: testPath as IndexPath) as! ProgressCell
                sum += (myObj.duration)
                let timeString = "\(NSString.createDurationStringFromDuration(Double(sum)))"
                percentage = (sum / Double(sumOfDay))*100
                let percentString = "\(round(percentage))%"
                nameString = "\(unique[i])"
                cell.percentLabel.text = "\(round(percentage))%"
                configureCell(cell , percentage: percentString, time: timeString, name: nameString)
            }
            percentArray.insert(percentage, at: 0)
            orderedNamesArray.insert(nameString, at: 0)
        }
        self.tableView.reloadData()
        setChart(orderedNamesArray, values: percentArray)
        let dayString = "\(NSString.createDurationStringFromDuration(Double(sumOfDay)))"
        pieChartView.centerText = ("Total time: \(dayString)")
    }
 

    @IBAction func calculateWeeklyActivities(_ sender: UIButton) {
        percentArray.removeAll()
        orderedNamesArray.removeAll()
        let weekActivitiesArray = DataHandler.fetchDataForWeekActivities()
        numberOfRows.removeAll()
        self.tableView.reloadData()
        var sumOfWeek: Double = 0
        if weekActivitiesArray.count > 0 {
            for history in weekActivitiesArray {
                sumOfWeek += (history.duration)
            }
        }
        var namesArray = [String]()
        for histname in weekActivitiesArray{
            namesArray.insert(histname.name!, at: 0)
        }
        
        let unique = Array(Set(namesArray))
        
        var sum: Double = 0
        var percentage: Double = 0
        var nameString: String = ""
        //TODO: modify below for different 
        if unique.count > 0 {
            for i in unique.indices{
                let activArr = data.filterResultsWeek(i: unique[i])
                let uniqueActivArr = Array(Set(activArr))
                sum = 0
            for myObj in uniqueActivArr {
                self.tableView.reloadData()
                let testPath = NSIndexPath(row: i, section: 0)
                let cell = tableView.cellForRow(at: testPath as IndexPath) as! ProgressCell
                sum += (myObj.duration)
                let timeString = "\(NSString.createDurationStringFromDuration(Double(sum)))"
                percentage = (sum / Double(sumOfWeek))*100
                let percentString = "\(round(percentage))%"
                nameString = "\(unique[i])"
                cell.percentLabel.text = "\(round(percentage))%"
                configureCell(cell , percentage: percentString, time: timeString, name: nameString)
                }
                percentArray.insert(percentage, at: 0)
                orderedNamesArray.insert(nameString, at: 0)
            }
        self.tableView.reloadData()
        setChart(orderedNamesArray, values: percentArray)
        let weekString = "\(NSString.createDurationStringFromDuration(Double(sumOfWeek)))"
        pieChartView.centerText = ("Total time: \(weekString)")

        }
    }
    

    @IBAction func calculateMonthlyActivities(_ sender: UIButton) {
        percentArray.removeAll()
        orderedNamesArray.removeAll()
        let monthActivitiesArray = data.fetchDataForMonthActivities()
        numberOfRows.removeAll()
        self.tableView.reloadData()
        var sumOfMonth: Double = 0
        if monthActivitiesArray.count > 0 {
            for history in monthActivitiesArray {
                sumOfMonth += (history.duration)
            }
            
        }
        var namesArray = [String]()
        for histname in monthActivitiesArray{
            namesArray.insert(histname.name!, at: 0)
        }
        
        let unique = Array(Set(namesArray))
        
        var sum: Double = 0
        var percentage: Double = 0
        var nameString: String = ""
        
        for i in unique.indices{
            let activArr = data.filterResultsMonth(i: unique[i])
            let uniqueActivArr = Array(Set(activArr))
            sum = 0
            for myObj in uniqueActivArr {
                numberOfRows.insert("test", at: 0)
                    let testPath = NSIndexPath(row: i, section: 0)
                    self.tableView.reloadData()
                    let cell = tableView.cellForRow(at: testPath as IndexPath) as! ProgressCell
                    sum += (myObj.duration)
                    let timeString = "\(NSString.createDurationStringFromDuration(Double(sum)))"
                    percentage = (sum / Double(sumOfMonth))*100
                    let percentString = "\(round(percentage))%"
                    nameString = "\(unique[i])"
                    cell.percentLabel.text = "\(round(percentage))%"
                self.tableView.reloadData()
                configureCell(cell , percentage: percentString, time: timeString, name: nameString)
            }
            percentArray.insert(percentage, at: 0)
            orderedNamesArray.insert(nameString, at: 0)
        }
        self.tableView.reloadData()
        setChart(orderedNamesArray, values: percentArray)
        let monthString = "\(NSString.createDurationStringFromDuration(Double(sumOfMonth)))"
        pieChartView.centerText = ("Total time: \(monthString)")
        }
    
    func calculateRows(_ activitiesArray: [History]) -> Int {
        for item in activitiesArray{
            numberOfRows.insert(item.name!, at: 0)
        }

        let unique = Array(Set(numberOfRows))
        return unique.count
    }
    

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let unique = Array(Set(numberOfRows))
        return unique.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressCell", for: indexPath) as! ProgressCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func configureCell(_ cell: ProgressCell, percentage: String!, time: String!, name: String!)  {
        cell.backgroundColor = UIColor.white
        cell.nameLabel.text = "\(name)"
        cell.percentLabel.text = "\(percentage)"
        cell.timeLabel.text = "\(time)"
    }
    
func setChart(_ dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartView.legend.enabled = false
        pieChartView.chartDescription?.text = ""
    
        let colors = [UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1), UIColor(red: 164/255, green: 249/255, blue: 242/255, alpha: 1), UIColor(red: 210/255, green: 128/255, blue: 240/255, alpha: 1), UIColor(red: 131/255, green: 222/255, blue: 252/255, alpha: 1), UIColor(red: 144/255, green: 19/255, blue: 254/255, alpha: 1)]
        
        pieChartDataSet.colors = colors
        
    }
    
}
