//
//  NotificationHandler.swift
//  HAP
//
//  Created by Fredrik Loberg on 16/03/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class NotificationHandler {
    static var notificationListeners = NSMutableSet()

    class func scheduleAchievementNotifications(userInfo:UserInfo, force:Bool = false) {
        let scheduledNotifications = UIApplication.sharedApplication().scheduledLocalNotifications ?? []
        if !force && scheduledNotifications.count >= 64 { return }
        
        //fetching achievements ready for schedulazion
        let achievements = fetchUpcomingAchievementNotifications(userInfo)
        
        //return if no new notifications to schedule
        if !force && scheduledNotifications.first?.applicationIconBadgeNumber == 1 { return }
        
        //(re)scheduling the notifications
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        var badgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber
        
        for achievement in achievements.prefix(64) {
            let timeToCompletion = Double(achievement.timeToCompletion(userInfo))
            badgeNumber += 1
            scheduleNotification(NSDate(timeIntervalSinceNow: timeToCompletion), alertBody: "Du har oppnådd en ny milepæl!", badgeNumber: badgeNumber)
        }
    }
    
    class func scheduleNotification(fireDate:NSDate, alertBody:String, badgeNumber: Int) {
        //It’s important to note that you’re limited to scheduling 64 local notifications. If you schedule more, the system will keep the 64 soonest firing notifications and automatically discard the rest.
        
        let notification = UILocalNotification()
        notification.fireDate = fireDate
        notification.alertAction = "Ja"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.alertBody = alertBody
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.applicationIconBadgeNumber = badgeNumber
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    class func addNotificationRecievedListener(listener:NotificationRecievedListener) {
        notificationListeners.addObject(listener)
    }
    
    class func removeNotificationRecievedListener(listener:NotificationRecievedListener){
        notificationListeners.removeObject(listener)
    }
    
    class func syncListenerBadges(){
        for listener in notificationListeners.allObjects as! [NotificationRecievedListener] {
            listener.syncTabBadgeWithApplicationIconBadge()
        }
    }
    
    class func notifyNotificationRecieved(){
        for listener in notificationListeners.allObjects as! [NotificationRecievedListener] {
            listener.onRecieveNotification()
        }
    }
    
    private class func fetchUpcomingAchievementNotifications(userInfo:UserInfo) -> [Achievement]{
        let preferences = NSUserDefaults.standardUserDefaults()
        let minorMilestones = preferences.objectForKey(SettingsViewController.minorMilestoneSettingKey) as? Bool ?? true
        let milestones = preferences.objectForKey(SettingsViewController.milestoneSettingKey) as? Bool ?? true
        let economic = preferences.objectForKey(SettingsViewController.economicMilestoneSettingKey) as? Bool ?? true
        let health = preferences.objectForKey(SettingsViewController.healthSettingKey) as? Bool ?? true
        
        
        var achievements = AchievementDao().getAll()
            .filter({ $0.timeToCompletionIsCalculateable(userInfo) })
            .filter({ !$0.isComplete(userInfo) })
            
        if !minorMilestones { achievements = achievements.filter({ !$0.isInCategory(.MinorMilestone) }) }
        if !milestones { achievements = achievements.filter({ !$0.isInCategory(.Milestone) }) }
        if !economic { achievements = achievements.filter({ !$0.isInCategory(.Economic) }) }
        if !health { achievements = achievements.filter({ !$0.isInCategory(.Health) }) }
            
            
        return achievements.sort({ $0.timeToCompletion(userInfo) <= $1.timeToCompletion(userInfo) })
    }
    
    class func resetBadges(){
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        syncListenerBadges()
    }
}
