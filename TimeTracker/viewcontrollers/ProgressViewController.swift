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
         tableView.reloadData()
        var todaysActivitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataForTodayActivities()
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
        var percentArray = [String]()
        
        let unique = Array(Set(namesArray))
        
        var sum: Double = 0
        var percentage: Double = 0
        
        for i in unique.indices{
            var activArr = CoreDataHandler.sharedInstance.filterResultsDay(unique[i])
            var uniqueActivArr = Array(Set(activArr))
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
        
        tableView.reloadData()
    }
    
    @IBAction func calculateWeeklyActivities(sender: UIButton) {
        var weekActivitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataForWeekActivities()
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
        var percentArray = [String]()
        
        let unique = Array(Set(namesArray))
        
        var sum: Double = 0
        var percentage: Double = 0
        
        for i in unique.indices{
            var activArr = CoreDataHandler.sharedInstance.filterResultsWeek(unique[i])
            var uniqueActivArr = Array(Set(activArr))
            sum = 0
            for myObj in uniqueActivArr {
                var testPath = NSIndexPath(forRow: i, inSection: 0)
                var cell = tableView.cellForRowAtIndexPath(testPath) as! ProgressCell
                sum += (myObj.duration?.doubleValue)!
                var timeString = "\(NSString.createDurationStringFromDuration(Double(sum)))"
                percentage = (sum / Double(sumOfWeek))*100
                var percentString = "\(round(percentage))%"
                var nameString = "\(unique[i])"
                cell.percentLabel.text = "\(round(percentage))%"
                configureCell(cell as! ProgressCell, percentage: percentString, time: timeString, name: nameString)
            }
        }
        tableView.reloadData()
    }

    @IBAction func calculateMonthlyActivities(sender: UIButton) {
        var monthActivitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataForMonthActivities()
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
                    var testPath = NSIndexPath(forRow: i, inSection: 0)
                    var cell = tableView.cellForRowAtIndexPath(testPath) as! ProgressCell
                    sum += (myObj.duration?.doubleValue)!
                    var timeString = "\(NSString.createDurationStringFromDuration(Double(sum)))"
                    percentage = (sum / Double(sumOfMonth))*100
                    var percentString = "\(round(percentage))%"
                    var nameString = "\(unique[i])"
                    cell.percentLabel.text = "\(round(percentage))%"
                configureCell(cell as! ProgressCell, percentage: percentString, time: timeString, name: nameString)
                }
            }
        tableView.reloadData()
    }
    
    func calculateRows() -> Int {
        //use month for max number of rows
        let monthActivitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataForMonthActivities()
        var sum = 0
        var namesArray = [String]()
        for histname in monthActivitiesArray{
            namesArray.insert(histname.name!, atIndex: 0)
        }

        let unique = Array(Set(namesArray))
        return unique.count
    }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculateRows()
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
