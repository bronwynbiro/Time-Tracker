//
//  DateHelper.swift
//  TimeTracker
//
//  Created by Bronwyn Biro on 2016-05-12.
//  Copyright © 2016 Zappdesigntemplates. All rights reserved.
//

import Foundation

var todayDateFormatter: NSDateFormatter = {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "hh:mm"
    return dateFormatter
}()