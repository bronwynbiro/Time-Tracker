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
    @IBOutlet weak var testLabel: UITextField!
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var liftText: UITextField!
    @IBOutlet weak var workText: UITextField!
    
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
        var todaysActivitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataForTodayActivities()
        var sumOfToday = 0
        if todaysActivitiesArray.count > 0 {
            for history in todaysActivitiesArray {
                sumOfToday += (history.duration?.integerValue)!
            }
        }
        testLabel.text = "\(NSString.createDurationStringFromDuration(Double(sumOfToday)))"
    }
    
    @IBAction func calculateWeeklyActivities(sender: UIButton) {
        var weekActivitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataForWeekActivities()
        var sumOfWeek = 0
        if weekActivitiesArray.count > 0 {
            for history in weekActivitiesArray {
                sumOfWeek += (history.duration?.integerValue)!
            }
        }
        testLabel.text = "\(NSString.createDurationStringFromDuration(Double(sumOfWeek)))"
    }
    
    @IBAction func calculateMonthlyActivities(sender: UIButton) {
        var monthActivitiesArray = CoreDataHandler.sharedInstance.fetchCoreDataForMonthActivities()
        var sumOfMonth: Double = 0
        if monthActivitiesArray.count > 0 {
            for history in monthActivitiesArray {
                sumOfMonth += (history.duration?.doubleValue)!
            }
            
        }
        testLabel.text = "\(NSString.createDurationStringFromDuration(Double(sumOfMonth)))"
        var namesArray = [String]()
        for histname in monthActivitiesArray{
            namesArray.insert(histname.name!, atIndex: 0)
        }
        var percentArray = [String]()
        
        let unique = Array(Set(namesArray))
        
        var sum: Double = 0
        var percentage: Double = 0
        
        for i in unique.indices{
            var activArr = CoreDataHandler.sharedInstance.filterResults(unique[i])
            var uniqueActivArr = Array(Set(activArr))
            sum = 0
            for myObj in uniqueActivArr {
                let testPath1 = NSIndexPath(forRow:0, inSection: 0)
                 var cell1 = tableView.cellForRowAtIndexPath(testPath1) as! ProgressCell
                if myObj.name == "lift" {
                    sum += (myObj.duration?.doubleValue)!
                    percentage = (sum / Double(sumOfMonth))*100
                    print("\(unique[i]): percent \(percentage)")
                    liftText.text = "Percentage of \(unique[i]): \(round(percentage))%"
                    var percentString = "\(round(percentage))%"
                    var nameString = "\(unique[i])"
                    cell1.percentLabel.text = "\(round(percentage))%"
                    configureCell(cell1 as! ProgressCell, percentage: percentString, name: nameString)
                }
                else {
                let testPath = NSIndexPath(forRow:1, inSection: 0)
                    var cell = tableView.cellForRowAtIndexPath(testPath) as! ProgressCell
                    sum += (myObj.duration?.doubleValue)!
                    percentage = (sum / Double(sumOfMonth))*100
                    print("\(unique[i]): percent \(percentage)")
                    workText.text = "Percentage of \(unique[i]): \(round(percentage))%"
                    var nameString = "\(unique[i])"
                    var percentString = "\(round(percentage))%"
                    cell.percentLabel.text = "\(round(percentage))%"
                    configureCell(cell as! ProgressCell, percentage: percentString, name: nameString)
                }
            }
        }
        tableView.reloadData()
    }
    
    func calculateRows() -> Int {
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
    
    func configureCell(cell: ProgressCell, percentage: String!, name: String!)  {
        cell.backgroundColor = UIColor.whiteColor()
       // cell.nameLabel.text = "\(todayDateFormatter.stringFromDate(history.startDate!)) - \(todayDateFormatter.stringFromDate(history.endDate!))"
        cell.nameLabel.text = "\(name)"
        cell.percentLabel.text = "\(percentage)"
       /// cell.percentLabel.text = NSString.createDurationStringFromDuration((history.duration?.doubleValue)!)
}

}
