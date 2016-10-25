//
//  NSDateExtension.swift
//  HAP
//
//  Created by Simen Fonnes on 05.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

extension Date {
    func dateWithTimeAsOfNowOf() -> Date{
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.hour, .minute, .second], from: Date())
        return (calendar as NSCalendar).date(bySettingHour: components.hour!, minute: components.minute!, second: components.second!, of: self, options: [])!
    }
    
    func dateWithTimeAsStartOfDayOf() -> Date{
        //NSTimeZone.setDefaultTimeZone(TimeZone.init(identifier: "CET")!)
        NSTimeZone.default = TimeZone(abbreviation: "CET")!
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
}
