//
//  ResetViewController.swift
//  HAP
//
//  Created by Fredrik Loberg on 26/04/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class ResetViewController: UITableViewController {
    static let storyboardId = "Reset"
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let tableSelection = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(tableSelection, animated: true)
        }
        
        switch indexPath.row {
        case 0: resetClockPromt()
        case 1: resetPositiveTriggersPromt()
        case 2: resetNegativeTirggersPromt()
        case 3: resetAppPromt()
        default: ()
        }
    }
    
    private func resetClockPromt(){
        let alert = UIAlertController(title: "Tilbakestill klokken", message: "Denne handlingen kan ikke angres.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Tilbakestill bare klokken", style: .Destructive, handler: { result in self.resetClock(keepAchievements: true) }))
        alert.addAction(UIAlertAction(title: "Tilbakestill klokken og prestasjoner", style: .Destructive, handler: { result in self.resetClock(keepAchievements: false) }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func resetPositiveTriggersPromt() {
        let alert = UIAlertController(title: "Tilbakestill positive triggere", message: "Denne handlingen kan ikke angres.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Tilbakestill", style: .Destructive, handler: { result in self.resetPositiveTriggers() }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func resetNegativeTirggersPromt(){
        let alert = UIAlertController(title: "Tilbakestill negative triggere", message: "Denne handlingen kan ikke angres.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Tilbakestill", style: .Destructive, handler: { result in self.resetNegativeTriggers() }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func resetAppPromt() {
        let alert = UIAlertController(title: "Advarsel!", message: "Er du sikker på at du vil nullstille appen? Denne handlingen kan ikke tilbakestilles.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Tilbakestill nå", style: .Destructive, handler: { result in self.resetApp() }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func resetClock(keepAchievements keepAchievements:Bool) {
        let userInfoDao = UserInfoDao()
        let userInfo = AppDelegate.getUserInfo()
        
        userInfo?.secondsLastedBeforeLastReset = keepAchievements ? userInfo!.timeInSecondsSinceStarted() : 0
        userInfo?.startDate = NSDate()
        userInfoDao.save()
        AppDelegate.initUserInfo()
        
        NotificationHandler.resetBadges()
        NotificationHandler.scheduleAchievementNotifications(userInfo!, force: true)
        SwiftEventBus.post(AchievementsTableController.RELOAD_ACHIEVEMENTS_EVENT)
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func resetPositiveTriggers(){
        let userInfoDao = UserInfoDao()
        let userInfo = AppDelegate.getUserInfo()
        
        userInfoDao.deleteObjects(userInfo?.getResistedTriggersAsArray() ?? [])
        userInfoDao.save()
        AppDelegate.initUserInfo()
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func resetNegativeTriggers(){
        let userInfoDao = UserInfoDao()
        let userInfo = AppDelegate.getUserInfo()
        
        userInfoDao.deleteObjects(userInfo?.getSmokedTriggersAsArray() ?? [])
        userInfoDao.save()
        AppDelegate.initUserInfo()
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func resetApp() {
        let userInfoDao = UserInfoDao()
        userInfoDao.delete(AppDelegate.getUserInfo()!)
        userInfoDao.save()
        AppDelegate.initUserInfo()
        //resetting badges happens in intro controller
        
        presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
    }
}
