//
//  Achievement.swift
//  HAP
//
//  Created by Simen Fonnes on 27.01.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Achievement: NSManagedObject {
    enum Category:String {
        case Economic, Health, Milestone, MinorMilestone
    }
    
    @NSManaged var title: String
    @NSManaged var info: String
    @NSManaged var pointsRequired: NSNumber
    @NSManaged var category: String
    
    func isInCategory(category: Category) -> Bool {
        return self.category == category.rawValue
    }
    
    func getProgress(userInfo: UserInfo) -> Double{
        let catAsEnum = Category(rawValue: category)
        
        switch catAsEnum {
        case .Milestone?, .MinorMilestone?, .Health?:
            let progressBeforeReset = userInfo.secondsLastedBeforeLastReset.doubleValue / pointsRequired.doubleValue
            if progressBeforeReset >= 1 { return progressBeforeReset }
            return userInfo.timeInSecondsSinceStarted() / pointsRequired.doubleValue
            
        case .Economic?:
            let moneySavedBeforeReset = userInfo.totalMoneySavedBeforeReset() / pointsRequired.doubleValue
            if moneySavedBeforeReset >= 1 { return moneySavedBeforeReset }
            return userInfo.totalMoneySaved() / pointsRequired.doubleValue
            
        default:
            return 0
        }
    }
    
    func isComplete(userInfo: UserInfo) -> Bool {
        return getProgress(userInfo) >= 1
    }
    
    func timeToCompletion(userInfo: UserInfo) -> Double {
        let catAsEnum = Category(rawValue: category)
        
        switch catAsEnum {
        case .Milestone?, .MinorMilestone?, .Health?:
            let seconds = userInfo.secondsLastedBeforeLastReset.doubleValue > 0
                ? max(userInfo.secondsLastedBeforeLastReset.doubleValue, userInfo.timeInSecondsSinceStarted())
                : userInfo.timeInSecondsSinceStarted()
            return pointsRequired.doubleValue - seconds
            
        case .Economic?:
            var moneySaved = userInfo.totalMoneySaved()
            let moneySavedBeforeReset = userInfo.totalMoneySavedBeforeReset() / pointsRequired.doubleValue
            if moneySavedBeforeReset >= 1 { moneySaved = userInfo.totalMoneySavedBeforeReset() }
            
            return (pointsRequired.doubleValue - moneySaved) / userInfo.moneySavedPerSecond()
            
        default:
            return 0
        }
    }
    
    func getIcon(userInfo: UserInfo) -> UIImage{
        var imgName = category
        
        if !isComplete(userInfo) { imgName += "White" }
        return UIImage(named: imgName)!
    }
    
    func timeToCompletionIsCalculateable(userInfo:UserInfo) ->Bool{
        let catAsEnum = Category(rawValue: category)
        
        switch catAsEnum{
        case .Milestone?, .MinorMilestone?, .Health?: return true
        case .Economic?: return userInfo.moneySavedPerSecond() > 0
        default: return false
        }
    }
}