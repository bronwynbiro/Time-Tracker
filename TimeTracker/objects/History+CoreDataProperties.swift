//
//  History+CoreDataProperties.swift
//  TimeTracker
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension History {

    /// time when the activity was saved for later sorting
    @NSManaged var saveTime: String?
    /// start date of history
    @NSManaged var startDate: NSDate?
    /// name of history
    @NSManaged var name: String?
    /// end date of history
    @NSManaged var endDate: NSDate?
    /// duration of the activity
    @NSManaged var duration: NSNumber?

}
