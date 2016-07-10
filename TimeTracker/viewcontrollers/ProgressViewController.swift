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

//class ProgressViewController: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {
class ProgressViewController: UIViewController {
    @IBOutlet weak var testLabel: UITextField!
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    
    @IBOutlet weak var liftText: UITextField!
    @IBOutlet weak var workText: UITextField!
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
                if myObj.name == "lift" {
                    sum += (myObj.duration?.doubleValue)!
                    percentage = (sum / Double(sumOfMonth))*100
                    print("\(unique[i]): percent \(percentage)")
                    liftText.text = "Percentage of \(unique[i]): \(round(percentage))%"
                }
                else {
                    sum += (myObj.duration?.doubleValue)!
                    percentage = (sum / Double(sumOfMonth))*100
                    print("\(unique[i]): percent \(percentage)")
                    workText.text = "Percentage of \(unique[i]): \(round(percentage))%"
                    
                }
            }
        }
    }
}