//
//  ProgressViewController.swift
//  TimeTracker

//
//  ActivityListViewController.swift
//  TimeTracker
//


import UIKit
import Foundation
import CoreData

class ProgressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//class ProgressViewController: UIViewController {
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var numberOfRows = ["test1"]
    
    override func viewDidLoad() {
        title = "Progress"
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorColor = color.pink()
        tableView.backgroundColor = UIColor.whiteColor()
        //  suvar.viewDidLoad()
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
        let percentArray = [String]()
        
        let unique = Array(Set(namesArray))
        
        var sum: Double = 0
        var percentage: Double = 0
        
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
                var nameString = "\(unique[i])"
                cell.percentLabel.text = "\(round(percentage))%"
                configureCell(cell as! ProgressCell, percentage: percentString, time: timeString, name: nameString)
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func calculateWeeklyActivities(sender: UIButton) {
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
        if unique.count > 0 {
            for i in unique.indices{
                let activArr = CoreDataHandler.sharedInstance.filterResultsWeek(unique[i])
                let uniqueActivArr = Array(Set(activArr))
                sum = 0
                if uniqueActivArr.count > 0 {
            for myObj in uniqueActivArr {
                self.tableView.reloadData()
                let testPath = NSIndexPath(forRow: i, inSection: 0)
                let cell = tableView.cellForRowAtIndexPath(testPath) as! ProgressCell
                sum += (myObj.duration?.doubleValue)!
                var timeString = "\(NSString.createDurationStringFromDuration(Double(sum)))"
                percentage = (sum / Double(sumOfWeek))*100
                let percentString = "\(round(percentage))%"
                let nameString = "\(unique[i])"
                cell.percentLabel.text = "\(round(percentage))%"
                configureCell(cell as! ProgressCell, percentage: percentString, time: timeString, name: nameString)
                    }
                }
            }
        }
        calculateRows(weekActivitiesArray)
        self.tableView.reloadData()
    }

    @IBAction func calculateMonthlyActivities(sender: UIButton) {
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
        //testLabel.text = "\(NSString.createDurationStringFromDuration(Double(sumOfMonth)))"
        var namesArray = [String]()
        for histname in monthActivitiesArray{
            namesArray.insert(histname.name!, atIndex: 0)
        }
        var percentArray = [String]()
        
        let unique = Array(Set(namesArray))
        
        var sum: Double = 0
        var percentage: Double = 0
        
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
                    var nameString = "\(unique[i])"
                    cell.percentLabel.text = "\(round(percentage))%"
                self.tableView.reloadData()
                configureCell(cell as! ProgressCell, percentage: percentString, time: timeString, name: nameString)
                }
            }
        calculateRows(monthActivitiesArray)
        self.tableView.reloadData()
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
       // configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func configureCell(cell: ProgressCell, percentage: String!, time: String!, name: String!)  {
        cell.backgroundColor = UIColor.whiteColor()
       // cell.nameLabel.text = "\(todayDateFormatter.stringFromDate(history.startDate!)) - \(todayDateFormatter.stringFromDate(history.endDate!))"
        cell.nameLabel.text = "\(name)"
        cell.percentLabel.text = "\(percentage)"
        cell.timeLabel.text = "\(time)"
       /// cell.percentLabel.text = NSString.createDurationStringFromDuration((history.duration?.doubleValue)!)
}

}
