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

    class func scheduleAchievementNotifications(_ userInfo:UserInfo, force:Bool = false) {
        let scheduledNotifications = UIApplication.shared.scheduledLocalNotifications ?? []
        if !force && scheduledNotifications.count >= 64 { return }
        
        //fetching achievements ready for schedulazion
        let achievements = fetchUpcomingAchievementNotifications(userInfo)
        
        //return if no new notifications to schedule
        if !force && scheduledNotifications.first?.applicationIconBadgeNumber == 1 { return }
        
        //(re)scheduling the notifications
        UIApplication.shared.cancelAllLocalNotifications()
        var badgeNumber = UIApplication.shared.applicationIconBadgeNumber
        
        for achievement in achievements.prefix(64) {
            let timeToCompletion = Double(achievement.timeToCompletion(userInfo))
            badgeNumber += 1
            scheduleNotification(Date(timeIntervalSinceNow: timeToCompletion), alertBody: "Du har oppnådd en ny milepæl!", badgeNumber: badgeNumber)
        }
    }
    
    class func scheduleNotification(_ fireDate:Date, alertBody:String, badgeNumber: Int) {
        //It’s important to note that you’re limited to scheduling 64 local notifications. If you schedule more, the system will keep the 64 soonest firing notifications and automatically discard the rest.
        
        let notification = UILocalNotification()
        notification.fireDate = fireDate
        notification.alertAction = "Ja"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.alertBody = alertBody
        notification.timeZone = TimeZone.current
        notification.applicationIconBadgeNumber = badgeNumber
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    class func addNotificationRecievedListener(_ listener:NotificationRecievedListener) {
        notificationListeners.add(listener)
    }
    
    class func removeNotificationRecievedListener(_ listener:NotificationRecievedListener){
        notificationListeners.remove(listener)
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
    
    fileprivate class func fetchUpcomingAchievementNotifications(_ userInfo:UserInfo) -> [Achievement]{
        let preferences = UserDefaults.standard
        let minorMilestones = preferences.object(forKey: SettingsViewController.minorMilestoneSettingKey) as? Bool ?? true
        let milestones = preferences.object(forKey: SettingsViewController.milestoneSettingKey) as? Bool ?? true
        let economic = preferences.object(forKey: SettingsViewController.economicMilestoneSettingKey) as? Bool ?? true
        let health = preferences.object(forKey: SettingsViewController.healthSettingKey) as? Bool ?? true
        
        
        var achievements = AchievementDao().getAll()
            .filter({ $0.timeToCompletionIsCalculateable(userInfo) })
            .filter({ !$0.isComplete(userInfo) })
            
        if !minorMilestones { achievements = achievements.filter({ !$0.isInCategory(.MinorMilestone) }) }
        if !milestones { achievements = achievements.filter({ !$0.isInCategory(.Milestone) }) }
        if !economic { achievements = achievements.filter({ !$0.isInCategory(.Economic) }) }
        if !health { achievements = achievements.filter({ !$0.isInCategory(.Health) }) }
            
            
        return achievements.sorted(by: { $0.timeToCompletion(userInfo) <= $1.timeToCompletion(userInfo) })
    }
    
    class func resetBadges(){
        UIApplication.shared.applicationIconBadgeNumber = 0
        syncListenerBadges()
    }
}
