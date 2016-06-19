//
//  NSDateHelper.swift
//  TimeTracker
//

import Foundation

extension NSDate {

    /**
    Returns an NSDate object which represents the start of the day. (like: 0:00:00 hour)

    - returns: converted date
    */
    class func dateByMovingToBeginningOfDay() -> NSDate {
        let components: NSDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: NSDate())
        components.hour = 0
        components.minute = 0
        components.second = 0
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }

    /**
    Returns an NSDate object which represents the end of the day. (like: 23:59:59 hour)

    - returns: converted date
    */
    class func dateByMovingToEndOfDay() -> NSDate {
        let components: NSDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: NSDate())
        components.hour = 23
        components.minute = 59
        components.second = 59
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    //EDIT: may have to change NSDate() as toDate to specifc date
    class func dateSevenDaysAgo () -> NSDate {
        let periodComponents = NSDateComponents()
        periodComponents.day = -7
        let then = NSCalendar.currentCalendar().dateByAddingComponents(
            periodComponents,
            toDate: NSDate(),
            options: [])!
        return then
    }
    
    class func dateMonthAgo () -> NSDate {
        let periodComponents = NSDateComponents()
        periodComponents.month = -1
        let then = NSCalendar.currentCalendar().dateByAddingComponents(
            periodComponents,
            toDate: NSDate(),
            options: [])!
        return then
    }

}