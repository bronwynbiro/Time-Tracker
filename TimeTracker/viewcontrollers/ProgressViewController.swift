import UIKit
import Foundation
import CoreData
//import Charts

class progressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var numberOfRows = ["test1"]
    var percentArray = [Double]()
    var orderedNamesArray = [String]()
    @IBOutlet var pieChartView: PieChartView!

    
    override func viewDidLoad() {
        title = "Progress"
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorColor = color.pink()
        tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        loadNormalState()
        tableView.reloadData()
    }
    
    func loadNormalState() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.backBarButtonItem?.action = Selector("backButtonPressed")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("editButtonPressed"))
    }
    

    
    @IBAction func calculateTodaysActivities(sender: UIButton) {
        percentArray.removeAll()
        orderedNamesArray.removeAll()
        let todaysActivitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataForTodayActivities()
        numberOfRows.removeAll()
        calculateRows(todaysActivitiesArray)
        self.tableView.reloadData()
        var sumOfDay = 0
        if todaysActivitiesArray.count > 0 {
            for history in todaysActivitiesArray {
                sumOfDay += (history.duration?.integerValue)!
            }
        }
        var namesArray = [String]()
        for histname in todaysActivitiesArray{
            namesArray.insert(histname.name!, atIndex: 0)
        }
        
        let unique = Array(Set(namesArray))
        
        var sum: Double = 0
        var percentage: Double = 0
        var nameString: String = " "
        
        for i in unique.indices{
            let activArr = CoreDataHandler.sharedInstance.filterResultsDay(unique[i])
            let uniqueActivArr = Array(Set(activArr))
            sum = 0
            for myObj in uniqueActivArr {
                var testPath = NSIndexPath(forRow: i, inSection: 0)
                var cell = tableView.cellForRowAtIndexPath(testPath) as! ProgressCell
                sum += (myObj.duration?.doubleValue)!
                var timeString = "\(NSString.createDurationStringFromDuration(Double(sum)))"
                percentage = (sum / Double(sumOfDay))*100
                var percentString = "\(round(percentage))%"
                nameString = "\(unique[i])"
                cell.percentLabel.text = "\(round(percentage))%"
                configureCell(cell as! ProgressCell, percentage: percentString, time: timeString, name: nameString)
            }
            percentArray.insert(percentage, atIndex: 0)
            orderedNamesArray.insert(nameString, atIndex: 0)
        }
        print("names array ordered", orderedNamesArray)
        print("percentArr", percentArray)
        calculateRows(todaysActivitiesArray)
        self.tableView.reloadData()
        setChart(orderedNamesArray, values: percentArray)
        let dayString = "\(NSString.createDurationStringFromDuration(Double(sumOfDay)))"
        pieChartView.centerText = ("Total time: \(dayString)")
    }
 

    @IBAction func calculateWeeklyActivities(sender: UIButton) {
        percentArray.removeAll()
        orderedNamesArray.removeAll()
        var weekActivitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataForWeekActivities()
        numberOfRows.removeAll()
        calculateRows(weekActivitiesArray)
        self.tableView.reloadData()
        var sumOfWeek = 0
        if weekActivitiesArray.count > 0 {
            for history in weekActivitiesArray {
                sumOfWeek += (history.duration?.integerValue)!
            }
        }
        var namesArray = [String]()
        for histname in weekActivitiesArray{
            namesArray.insert(histname.name!, atIndex: 0)
        }
        
        let unique = Array(Set(namesArray))
        
        var sum: Double = 0
        var percentage: Double = 0
        var nameString: String = ""
        
        if unique.count > 0 {
            for i in unique.indices{
                let activArr = CoreDataHandler.sharedInstance.filterResultsWeek(unique[i])
                let uniqueActivArr = Array(Set(activArr))
                sum = 0
            for myObj in uniqueActivArr {
                self.tableView.reloadData()
                let testPath = NSIndexPath(forRow: i, inSection: 0)
                let cell = tableView.cellForRowAtIndexPath(testPath) as! ProgressCell
                sum += (myObj.duration?.doubleValue)!
                var timeString = "\(NSString.createDurationStringFromDuration(Double(sum)))"
                percentage = (sum / Double(sumOfWeek))*100
                let percentString = "\(round(percentage))%"
                nameString = "\(unique[i])"
                cell.percentLabel.text = "\(round(percentage))%"
                configureCell(cell as! ProgressCell, percentage: percentString, time: timeString, name: nameString)
                }
                percentArray.insert(percentage, atIndex: 0)
                orderedNamesArray.insert(nameString, atIndex: 0)
            }
            print("names array ordered", orderedNamesArray)
            print("percentArr", percentArray)
        calculateRows(weekActivitiesArray)
        self.tableView.reloadData()
        setChart(orderedNamesArray, values: percentArray)
        let weekString = "\(NSString.createDurationStringFromDuration(Double(sumOfWeek)))"
        pieChartView.centerText = ("Total time: \(weekString)")

        }
    }
    

    @IBAction func calculateMonthlyActivities(sender: UIButton) {
        percentArray.removeAll()
        orderedNamesArray.removeAll()
        var monthActivitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataForMonthActivities()
        numberOfRows.removeAll()
        calculateRows(monthActivitiesArray)
        self.tableView.reloadData()
        var sumOfMonth: Double = 0
        if monthActivitiesArray.count > 0 {
            for history in monthActivitiesArray {
                sumOfMonth += (history.duration?.doubleValue)!
            }
            
        }
        var namesArray = [String]()
        for histname in monthActivitiesArray{
            namesArray.insert(histname.name!, atIndex: 0)
        }
        
        let unique = Array(Set(namesArray))
        
        var sum: Double = 0
        var percentage: Double = 0
        var nameString: String = ""
        
        for i in unique.indices{
            var activArr = CoreDataHandler.sharedInstance.filterResultsMonth(unique[i])
            var uniqueActivArr = Array(Set(activArr))
            sum = 0
            for myObj in uniqueActivArr {
                numberOfRows.insert("test", atIndex: 0)
                    var testPath = NSIndexPath(forRow: i, inSection: 0)
                    self.tableView.reloadData()
                    var cell = tableView.cellForRowAtIndexPath(testPath) as! ProgressCell
                    sum += (myObj.duration?.doubleValue)!
                    var timeString = "\(NSString.createDurationStringFromDuration(Double(sum)))"
                    percentage = (sum / Double(sumOfMonth))*100
                    var percentString = "\(round(percentage))%"
                    nameString = "\(unique[i])"
                    cell.percentLabel.text = "\(round(percentage))%"
                self.tableView.reloadData()
                configureCell(cell as! ProgressCell, percentage: percentString, time: timeString, name: nameString)
            }
            percentArray.insert(percentage, atIndex: 0)
            orderedNamesArray.insert(nameString, atIndex: 0)
        }
        print("names array ordered", orderedNamesArray)
        print("percentArr", percentArray)
        calculateRows(monthActivitiesArray)
        self.tableView.reloadData()
        setChart(orderedNamesArray, values: percentArray)
        let monthString = "\(NSString.createDurationStringFromDuration(Double(sumOfMonth)))"
        pieChartView.centerText = ("Total time: \(monthString)")
        }
    
    func calculateRows(activitiesArray: [History]) -> Int {
        var sum = 0
        for item in activitiesArray{
            numberOfRows.insert(item.name!, atIndex: 0)
        }

        let unique = Array(Set(numberOfRows))
        return unique.count
    }
    

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let unique = Array(Set(numberOfRows))
        return unique.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProgressCell", forIndexPath: indexPath) as! ProgressCell
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func configureCell(cell: ProgressCell, percentage: String!, time: String!, name: String!)  {
        cell.backgroundColor = UIColor.whiteColor()
        cell.nameLabel.text = "\(name)"
        cell.percentLabel.text = "\(percentage)"
        cell.timeLabel.text = "\(time)"
    }
    
func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartView.legend.enabled = false
        pieChartView.descriptionText = ""
    
        let colors = [UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1), UIColor(red: 164/255, green: 249/255, blue: 242/255, alpha: 1), UIColor(red: 210/255, green: 128/255, blue: 240/255, alpha: 1), UIColor(red: 131/255, green: 222/255, blue: 252/255, alpha: 1), UIColor(red: 144/255, green: 19/255, blue: 254/255, alpha: 1)]
        
        pieChartDataSet.colors = colors
        
    }
    
}