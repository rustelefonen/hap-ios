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
        
        SwiftEventBus.onMainThread(eventBusTarget as AnyObject, name: MainTabBarController.GO_TO_PAGE_EVENT, handler: {[weak self] result in
            self?.selectedIndex = (result.object as? Int)! ?? 0
        })
        
        //calling viewDidLoad on all tabs, to let them subscribe on eventbus etc..
         for viewController in viewControllers ?? []{
            viewController.childViewControllers.first?.view
         }
    }
    
    deinit {
        print("deiniting tabbar!!!")
        SwiftEventBus.unregister(eventBusTarget as AnyObject)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationHandler.addNotificationRecievedListener(self)
        syncTabBadgeWithApplicationIconBadge()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationHandler.removeNotificationRecievedListener(self)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.childViewControllers.first is AchievementsTableController{
            syncTabBadgeWithApplicationIconBadge()
        }
    }
    
    func onRecieveNotification() {
        UIApplication.shared.applicationIconBadgeNumber += 1
        syncTabBadgeWithApplicationIconBadge()
    }
    
    func syncTabBadgeWithApplicationIconBadge(){
        updateBadgeValuesToReflect(value: UIApplication.shared.applicationIconBadgeNumber)
        
        let achievementTab = tabBar.items?[MainTabBarController.ACHIEVEMENT_TAB_INDEX]
        
        if selectedIndex == MainTabBarController.ACHIEVEMENT_TAB_INDEX && achievementTab?.badgeValue != nil{
            SwiftEventBus.post(AchievementsTableController.ACHIEVEMENT_UNLOCKED_EVENT)
            achievementTab?.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
            NotificationHandler.scheduleAchievementNotifications(AppDelegate.getUserInfo()!)
        }
    }
    
    func updateBadgeValuesToReflect(value: Int) {
        var tabBarBadge:String? = nil
        
        if value > MAX_BADGE_VALUE { tabBarBadge = "99+" }
        else if value > 0 { tabBarBadge = String(value) }
        
        tabBar.items?[MainTabBarController.ACHIEVEMENT_TAB_INDEX].badgeValue = tabBarBadge
        UIApplication.shared.applicationIconBadgeNumber = value
    }
    
    func displayOptionsMenu(_ sender:UIBarButtonItem) {
        UIOverlay.despawnAllOverlays()
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let popover = alertController.popoverPresentationController { //for ipad
            popover.barButtonItem = sender
            popover.permittedArrowDirections = .any
        }
        
        alertController.addAction(UIAlertAction(title: "Om Applikasjonen", style: .default, handler: { _ in self.navigateToAboutViewController() }))
        alertController.addAction(UIAlertAction(title: "Varslingsinnstillinger", style: .default, handler: { _ in self.navigateToSettingsViewController() }))
        alertController.addAction(UIAlertAction(title: "Tilbakestilling", style: .destructive, handler: { _ in self.navigateToResetViewController()}))
        alertController.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func navigateToAboutViewController() {
        let destination = storyboard?.instantiateViewController(withIdentifier: AboutViewController.storyboardId)
        (viewControllers![selectedIndex] as! UINavigationController).pushViewController(destination!, animated: true)
    }
    
    fileprivate func navigateToSettingsViewController() {
        let destination = storyboard?.instantiateViewController(withIdentifier: SettingsViewController.storyboardId)
        (viewControllers![selectedIndex] as! UINavigationController).pushViewController(destination!, animated: true)
    }
    
    fileprivate func navigateToResetViewController(){
        let destination = storyboard?.instantiateViewController(withIdentifier: ResetViewController.storyboardId)
        (viewControllers![selectedIndex] as! UINavigationController).pushViewController(destination!, animated: true)
    }
    
    func showInfoAlert(_ alertTitle:String, alertMessage:String, actionTitle:String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
