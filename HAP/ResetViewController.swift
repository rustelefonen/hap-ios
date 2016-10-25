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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tableSelection = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: tableSelection, animated: true)
        }
        
        switch (indexPath as NSIndexPath).row {
        case 0: resetClockPromt()
        case 1: resetPositiveTriggersPromt()
        case 2: resetNegativeTirggersPromt()
        case 3: resetAppPromt()
        default: ()
        }
    }
    
    fileprivate func resetClockPromt(){
        let alert = UIAlertController(title: "Tilbakestill klokken", message: "Denne handlingen kan ikke angres.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tilbakestill bare klokken", style: .destructive, handler: { result in self.resetClock(keepAchievements: true) }))
        alert.addAction(UIAlertAction(title: "Tilbakestill klokken og prestasjoner", style: .destructive, handler: { result in self.resetClock(keepAchievements: false) }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func resetPositiveTriggersPromt() {
        let alert = UIAlertController(title: "Tilbakestill positive triggere", message: "Denne handlingen kan ikke angres.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tilbakestill", style: .destructive, handler: { result in self.resetPositiveTriggers() }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func resetNegativeTirggersPromt(){
        let alert = UIAlertController(title: "Tilbakestill negative triggere", message: "Denne handlingen kan ikke angres.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tilbakestill", style: .destructive, handler: { result in self.resetNegativeTriggers() }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func resetAppPromt() {
        let alert = UIAlertController(title: "Advarsel!", message: "Er du sikker på at du vil nullstille appen? Denne handlingen kan ikke tilbakestilles.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tilbakestill nå", style: .destructive, handler: { result in self.resetApp() }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func resetClock(keepAchievements:Bool) {
        let userInfoDao = UserInfoDao()
        let userInfo = AppDelegate.getUserInfo()
        
        userInfo?.secondsLastedBeforeLastReset = keepAchievements ? NSNumber(value: userInfo!.timeInSecondsSinceStarted()) : NSNumber(value: 0)
        userInfo?.startDate = Date()
        userInfoDao.save()
        AppDelegate.initUserInfo()
        
        NotificationHandler.resetBadges()
        NotificationHandler.scheduleAchievementNotifications(userInfo!, force: true)
        SwiftEventBus.post(AchievementsTableController.RELOAD_ACHIEVEMENTS_EVENT)
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func resetPositiveTriggers(){
        let userInfoDao = UserInfoDao()
        let userInfo = AppDelegate.getUserInfo()
        
        userInfoDao.deleteObjects(userInfo?.getResistedTriggersAsArray() ?? [])
        userInfoDao.save()
        AppDelegate.initUserInfo()
        
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func resetNegativeTriggers(){
        let userInfoDao = UserInfoDao()
        let userInfo = AppDelegate.getUserInfo()
        
        userInfoDao.deleteObjects(userInfo?.getSmokedTriggersAsArray() ?? [])
        userInfoDao.save()
        AppDelegate.initUserInfo()
        
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func resetApp() {
        let userInfoDao = UserInfoDao()
        userInfoDao.delete(AppDelegate.getUserInfo()!)
        userInfoDao.save()
        AppDelegate.initUserInfo()
        //resetting badges happens in intro controller
        
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
}
