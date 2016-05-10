//
//  Activity+CoreDataProperties.swift
//  TimeTracker
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Activity {

    /// start date of activity
    @NSManaged var startDate: NSDate?
    /// end date of activity
    @NSManaged var endDate: NSDate?
    /// name of activity
    @NSManaged var name: String?

}
