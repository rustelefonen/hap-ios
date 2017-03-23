//
//  UserInfo.swift
//  HAP
//
//  Created by Simen Fonnes on 27.01.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import Foundation
import CoreData

class UserInfo: NSManagedObject {

    @NSManaged var age: String?
    @NSManaged var gender: String?
    @NSManaged var geoState: String?
    @NSManaged var userType: String?
    
    @NSManaged var moneySpentPerDayOnHash: NSNumber
    @NSManaged var startDate: Date
    @NSManaged var resistedTriggers: NSSet
    @NSManaged var smokedTriggers: NSSet
    @NSManaged var secondsLastedBeforeLastReset: NSNumber
    
    func timeInSecondsSinceStarted() -> Double{
        return timeInSecondsSinceDate(startDate)
    }
    
    func daysSinceStarted() -> Int{
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let theStartDate = (cal as NSCalendar).date(bySettingHour: 4, minute: 0, second: 0, of: startDate, options: [])!
        
        return Int(timeInSecondsSinceDate(theStartDate) / 86400)
    }
    
    func totalMoneySaved() -> Double {
        return moneySavedPerSecond() * timeInSecondsSinceStarted()
    }
    
    func totalMoneySavedBeforeReset() -> Double {
        return moneySavedPerSecond() * Double(secondsLastedBeforeLastReset)
    }
    
    func moneySavedPerSecond() -> Double {
        return moneySpentPerDayOnHash.doubleValue / 86400
    }
    
    func getResistedTriggersAsArray() -> [UserTrigger] {
        return resistedTriggers.allObjects as? [UserTrigger] ?? []
    }
    
    func getSmokedTriggersAsArray() -> [UserTrigger] {
        return smokedTriggers.allObjects as? [UserTrigger] ?? []
    }
    
    func incrementTriggerCountIfTriggerExists(_ trigger:Trigger, kind:UserTrigger.Kind) -> Bool {
        let userTriggers = kind == .Smoked ? getSmokedTriggersAsArray() : getResistedTriggersAsArray()
        
        for userTrigger in userTriggers {
            if userTrigger.getTrigger() == trigger {
                userTrigger.incrementCount()
                return true
            }
        }
        return false
    }
    
    fileprivate func timeInSecondsSinceDate(_ date:Date) -> Double {
        let seconds = -Double(date.timeIntervalSinceNow) // minus because .timeIntervalToNow is wanted
        if seconds.isNaN { return 0 }
        
        return seconds
    }
}
