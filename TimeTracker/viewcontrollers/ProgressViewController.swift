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
    @IBOutlet weak var workText: UITextField!
    @IBOutlet weak var liftText: UITextField!
    
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
                liftText.text = "Percentage of \(unique[i]): \(round(percentage))%)"
            }
            else {
                sum += (myObj.duration?.doubleValue)!
                percentage = (sum / Double(sumOfMonth))*100
                print("\(unique[i]): percent \(percentage)")
                workText.text = "Percentage of \(unique[i]): \(round(percentage))%)"
                
            }
            }
        }
    }
    
        /*
        var sumLift: Double = 0
        for myObj in monthActivitiesArray where myObj.name! == "lift" {
            sumLift += (myObj.duration?.doubleValue)!
            print("sum", sumLift)
        }
        var sumWork: Double = 0
        for myObj in monthActivitiesArray where myObj.name! == "work" {
            sumWork += (myObj.duration?.doubleValue)!
            print("sum", sumLift)
        }
        var percentageLift = (Double(sumLift) / Double(sumOfMonth))*100
        var percentageWork = (Double(sumWork) / Double(sumOfMonth))*100
        
        testLabel.text = "Percentage of lifting: \(round(percentageLift))%. Percentage work:\(round(percentageWork))%. Total hours: \(NSString.createDurationStringFromDuration(Double(sumOfMonth)))"
        
        print("lift", sumLift)
        print("Month", sumOfMonth)
 */
    
    
    
    ///////
    
    /*
     var percent = 0
     var duration = 0
     for history in monthActivitiesArray {
     duration += (history.duration?.integerValue)!
     percent = duration / sumOfMonth
     
     }
     testLabel.text = "\(NSString.createDurationStringFromDuration(Double(percent)))"
     
     
     // let managedContext : NSManagedObjectContext = CoreDataHandler.backgroundManagedContext!
     var fetchRequest = NSFetchRequest(entityName: "History")
     fetchRequest.returnsObjectsAsFaults = false;
     //fetchRequest.resultType = .DictionaryResultType
     // var results = CoreDataHandler.filterResults()
     
     fetchRequest.returnsObjectsAsFaults = false;
     var results: NSArray = CoreDataHandler.executeFetchRequest(fetchRequest, error: nil)!
     
     var totalHoursWorkedSum: Double = 0
     for res in results {
     var totalWorkTimeInHours = res.valueForKey("totalWorkTimeInHours") as! Double
     totalHoursWorkedSum += totalWorkTimeInHours
     }
     
     print("Sum = \(totalHoursWorkedSum)")
     }
     
     
     for i in 0 ..< monthActivitiesArray.count {
     var results = CoreDataHandler.sharedInstance.fetchCoreDataForMonthActivities()
     var testSum = 0
     var fetchSum = 0
     var percent = 0
     for res in results {
     fetchSum = res.valueForKey("duration") as! Int
     testSum += fetchSum
     }
     percent = fetchSum / testSum
     
     testLabel.text = "\(NSString.createDurationStringFromDuration(Double(percent)))"
     }
     }
     */
}