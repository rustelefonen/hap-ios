//
//  MainTabBarController.swift
//  HAP
//
//  Created by Simen Fonnes on 11.02.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

let MAX_BADGE_VALUE = 99

class MainTabBarController: UITabBarController, UITabBarControllerDelegate, NotificationRecievedListener {
    static let storyboardId = "MainController"
    static let GO_TO_PAGE_EVENT = "go_to_page_event"
    let eventBusTarget = 1
    
    static let HOME_TAB_INDEX = 0
    static let OVERVIEW_TAB_INDEX = 1
    static let ACHIEVEMENT_TAB_INDEX = 2
    static let INFO_TAB_INDEX = 3
    
    override func viewDidLoad() {
        delegate = self
        
        SwiftEventBus.onMainThread(eventBusTarget, name: MainTabBarController.GO_TO_PAGE_EVENT, handler: {[weak self] result in
            self?.selectedIndex = (result.object as? Int)! ?? 0
        })
        
        //calling viewDidLoad on all tabs, to let them subscribe on eventbus etc..
         for viewController in viewControllers ?? []{
            viewController.childViewControllers.first?.view
         }
    }
    
    deinit {
        print("deiniting tabbar!!!")
        SwiftEventBus.unregister(eventBusTarget)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NotificationHandler.addNotificationRecievedListener(self)
        syncTabBadgeWithApplicationIconBadge()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationHandler.removeNotificationRecievedListener(self)
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if viewController.childViewControllers.first is AchievementsTableController{
            syncTabBadgeWithApplicationIconBadge()
        }
    }
    
    func onRecieveNotification() {
        UIApplication.sharedApplication().applicationIconBadgeNumber += 1
        syncTabBadgeWithApplicationIconBadge()
    }
    
    func syncTabBadgeWithApplicationIconBadge(){
        updateBadgeValuesToReflect(value: UIApplication.sharedApplication().applicationIconBadgeNumber)
        
        let achievementTab = tabBar.items?[MainTabBarController.ACHIEVEMENT_TAB_INDEX]
        
        if selectedIndex == MainTabBarController.ACHIEVEMENT_TAB_INDEX && achievementTab?.badgeValue != nil{
            SwiftEventBus.post(AchievementsTableController.ACHIEVEMENT_UNLOCKED_EVENT)
            achievementTab?.badgeValue = nil
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            NotificationHandler.scheduleAchievementNotifications(AppDelegate.getUserInfo()!)
        }
    }
    
    func updateBadgeValuesToReflect(value value: Int) {
        var tabBarBadge:String? = nil
        
        if value > MAX_BADGE_VALUE { tabBarBadge = "99+" }
        else if value > 0 { tabBarBadge = String(value) }
        
        tabBar.items?[MainTabBarController.ACHIEVEMENT_TAB_INDEX].badgeValue = tabBarBadge
        UIApplication.sharedApplication().applicationIconBadgeNumber = value
    }
    
    func displayOptionsMenu(sender:UIBarButtonItem) {
        UIOverlay.despawnAllOverlays()
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        if let popover = alertController.popoverPresentationController { //for ipad
            popover.barButtonItem = sender
            popover.permittedArrowDirections = .Any
        }
        
        alertController.addAction(UIAlertAction(title: "Om Applikasjonen", style: .Default, handler: { _ in self.navigateToAboutViewController() }))
        alertController.addAction(UIAlertAction(title: "Varslingsinnstillinger", style: .Default, handler: { _ in self.navigateToSettingsViewController() }))
        alertController.addAction(UIAlertAction(title: "Tilbakestilling", style: .Destructive, handler: { _ in self.navigateToResetViewController()}))
        alertController.addAction(UIAlertAction(title: "Avbryt", style: .Cancel, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func navigateToAboutViewController() {
        let destination = storyboard?.instantiateViewControllerWithIdentifier(AboutViewController.storyboardId)
        (viewControllers![selectedIndex] as! UINavigationController).pushViewController(destination!, animated: true)
    }
    
    private func navigateToSettingsViewController() {
        let destination = storyboard?.instantiateViewControllerWithIdentifier(SettingsViewController.storyboardId)
        (viewControllers![selectedIndex] as! UINavigationController).pushViewController(destination!, animated: true)
    }
    
    private func navigateToResetViewController(){
        let destination = storyboard?.instantiateViewControllerWithIdentifier(ResetViewController.storyboardId)
        (viewControllers![selectedIndex] as! UINavigationController).pushViewController(destination!, animated: true)
    }
    
    func showInfoAlert(alertTitle:String, alertMessage:String, actionTitle:String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}