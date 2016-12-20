import Foundation

extension Date {

    /**
    Returns an NSDate object which represents the start of the day. (like: 0:00:00 hour)

    - returns: converted date
    */
    static func dateByMovingToBeginningOfDay() -> Date {
        var components: DateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second], from: Date())
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Calendar.current.date(from: components)!
    }

    /**
    Returns an NSDate object which represents the end of the day. (like: 23:59:59 hour)

    - returns: converted date
    */
    static func dateByMovingToEndOfDay() -> Date {
        var components: DateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second], from: Date())
        components.hour = 23
        components.minute = 59
        components.second = 59
        return Calendar.current.date(from: components)!
    }
    //EDIT: may have to change NSDate() as toDate to specifc date
    static func dateSevenDaysAgo () -> Date {
        var periodComponents = DateComponents()
        periodComponents.day = -7
        let then = (Calendar.current as NSCalendar).date(
            byAdding: periodComponents,
            to: Date(),
            options: [])!
        return then
    }
    
    static func dateMonthAgo () -> Date {
        var periodComponents = DateComponents()
        periodComponents.month = -1
        let then = (Calendar.current as NSCalendar).date(
            byAdding: periodComponents,
            to: Date(),
            options: [])!
        return then
    }

}
