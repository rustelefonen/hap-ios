//
//  NSDateExtension.swift
//  HAP
//
//  Created by Simen Fonnes on 05.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

extension NSDate {
    func dateWithTimeAsOfNowOf() -> NSDate{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second], fromDate: NSDate())
        return calendar.dateBySettingHour(components.hour, minute: components.minute, second: components.second, ofDate: self, options: [])!
    }
    
    func dateWithTimeAsStartOfDayOf() -> NSDate{
        NSTimeZone.setDefaultTimeZone(NSTimeZone.init(name: "CET")!)
        let calendar = NSCalendar.currentCalendar()
        return calendar.startOfDayForDate(self)
    }
}