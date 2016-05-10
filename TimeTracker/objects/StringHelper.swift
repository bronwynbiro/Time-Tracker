//
//  StringHelper.swift
//  TimeTracker
//


import Foundation

/**
    NSString extension to have most used nsstring methods in a separate class
*/

extension NSString {

    /**
    Creates a duration string from the passed in duration value. Format is 00:00:00

    - parameter duration: duration to value to use for displaying the duration

    - returns: NSString formatted duration string
    */
    class func createDurationStringFromDuration(duration: Double) -> String {
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 2

        let seconds = UInt8(duration % 60)
        let minutes = UInt8((duration / 60) % 60)
        let hours = UInt8((duration / 3600))

        let secondString = seconds > 9 ? String(seconds) : "0" + String(seconds)
        let minuteString = minutes > 9 ? String(minutes) : "0" + String(minutes)
        let hoursString = hours > 9 ? String(hours) : "0" + String(hours)

        let durationString = "\(hoursString):\(minuteString):\(secondString)"
        return durationString
    }

    /**
        Creates a string from the passed in integer
        - parameter time: integer to use for creating the time string
    */
    class func timeStringWithTimeToDisplay(time: Int) -> String {
        return String(format: "%.2d", time)
    }
}