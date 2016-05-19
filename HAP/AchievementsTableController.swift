//
//  AchievementsTableViewController.swift
//  HAP
//
//  Created by Simen Fonnes on 21.01.16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit
import CoreData

class AchievementsTableController: UITableViewController {
    static let RELOAD_ACHIEVEMENTS_EVENT = "reload_achievements_event"
    static let ACHIEVEMENT_UNLOCKED_EVENT = "achievement_unlocked_event"
    let eventBusTarget = 1
    
    @IBInspectable var nextUpcomingSectionHeader:String!
    @IBInspectable var completedSectionHeader:String!

    //Fields
    var achievements: [Achievement]!
    var nextUpcoming: Achievement?
    var achievementDAO: AchievementDao!
    var timer: NSTimer!
    var achievementGotUnlocked = false
    
    //Lifecycle operations
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadAchievementsTable()
        SwiftEventBus.onMainThread(eventBusTarget, name: AchievementsTableController.RELOAD_ACHIEVEMENTS_EVENT) {[weak self] _ in self?.reloadAchievementsTable() }
        SwiftEventBus.onMainThread(eventBusTarget, name: AchievementsTableController.ACHIEVEMENT_UNLOCKED_EVENT) {[weak self] _ in self?.handleNewAchievementUnlocked() }
    }
    
    deinit{
        SwiftEventBus.unregister(eventBusTarget)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if achievementGotUnlocked { showAchievementUnlockedAlert() }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    //Tableview operations
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? nextUpcoming != nil ? 1 : 0 : achievements.count
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        v.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 30))
        label.text = section == 0 ? nextUpcomingSectionHeader : completedSectionHeader
        
        v.addSubview(label)
        return v
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            performSegueWithIdentifier("allCategories", sender: nil)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AchievementCell
        cell.accessoryType = indexPath.section == 0 ? .DisclosureIndicator : .None
        cell.backgroundColor = indexPath.section == 0 ? UIColor.clearColor() : UIColor.whiteColor()
        
        let achievement = indexPath.section == 0 ? nextUpcoming! : achievements[indexPath.row]
        
        cell.imageViewContent.image = achievement.getIcon(AppDelegate.getUserInfo()!)
        cell.titleLabel.text = achievement.title
        cell.contentLabel.text = achievement.info
        
        setProgressOf(cell, achievement: achievement)
        return cell
    }
    
    private func setProgressOf(cell: AchievementCell, achievement: Achievement, animated:Bool = false){
        let progress = achievement.getProgress(AppDelegate.getUserInfo()!)
        cell.progressView.setProgress(Float(progress), animated: animated)
    }
    
    func updateProgress(){
        if nextUpcoming == nil { return } //first row might be out of sight == nil
        
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? AchievementCell{
            setProgressOf(cell, achievement: nextUpcoming!, animated: true)
            if nextUpcoming!.isComplete(AppDelegate.getUserInfo()!) { reloadAchievementsTable() }
        }
    }
    
    private func reloadAchievementsTable(){
        if(achievementDAO == nil) { achievementDAO = AchievementDao() }
        
        nextUpcoming = achievementDAO.fetchNextAchievement(AppDelegate.getUserInfo()!)
        achievements = achievementDAO.fetchCompletedAchievements(AppDelegate.getUserInfo()!).reverse()
        tableView.reloadData()
    }
    
    @IBAction func settingsAction(sender: UIBarButtonItem) {
        (tabBarController as? MainTabBarController)?.displayOptionsMenu(sender)
    }
    
    private func handleNewAchievementUnlocked() {
        reloadAchievementsTable()
        achievementGotUnlocked = true
    }
    
    private func showAchievementUnlockedAlert(){
        if let unlocked = achievements.first{
            let alert = UIAlertController(title: unlocked.title, message: unlocked.info, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            achievementGotUnlocked = false
        }
    }
}