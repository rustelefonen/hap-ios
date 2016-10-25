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
    var timer: Timer!
    var achievementGotUnlocked = false
    
    //Lifecycle operations
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadAchievementsTable()
        SwiftEventBus.onMainThread(eventBusTarget as AnyObject, name: AchievementsTableController.RELOAD_ACHIEVEMENTS_EVENT) {[weak self] _ in self?.reloadAchievementsTable() }
        SwiftEventBus.onMainThread(eventBusTarget as AnyObject, name: AchievementsTableController.ACHIEVEMENT_UNLOCKED_EVENT) {[weak self] _ in self?.handleNewAchievementUnlocked() }
    }
    
    deinit{
        SwiftEventBus.unregister(eventBusTarget as AnyObject)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if achievementGotUnlocked { showAchievementUnlockedAlert() }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    //Tableview operations
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? nextUpcoming != nil ? 1 : 0 : achievements.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        v.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 30))
        label.text = section == 0 ? nextUpcomingSectionHeader : completedSectionHeader
        
        v.addSubview(label)
        return v
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 0 && (indexPath as NSIndexPath).section == 0 {
            performSegue(withIdentifier: "allCategories", sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AchievementCell
        cell.accessoryType = (indexPath as NSIndexPath).section == 0 ? .disclosureIndicator : .none
        cell.backgroundColor = (indexPath as NSIndexPath).section == 0 ? UIColor.clear : UIColor.white
        
        let achievement = (indexPath as NSIndexPath).section == 0 ? nextUpcoming! : achievements[(indexPath as NSIndexPath).row]
        
        cell.imageViewContent.image = achievement.getIcon(AppDelegate.getUserInfo()!)
        cell.titleLabel.text = achievement.title
        cell.contentLabel.text = achievement.info
        
        setProgressOf(cell, achievement: achievement)
        return cell
    }
    
    fileprivate func setProgressOf(_ cell: AchievementCell, achievement: Achievement, animated:Bool = false){
        let progress = achievement.getProgress(AppDelegate.getUserInfo()!)
        cell.progressView.setProgress(Float(progress), animated: animated)
    }
    
    func updateProgress(){
        if nextUpcoming == nil { return } //first row might be out of sight == nil
        
        if let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? AchievementCell{
            setProgressOf(cell, achievement: nextUpcoming!, animated: true)
            if nextUpcoming!.isComplete(AppDelegate.getUserInfo()!) { reloadAchievementsTable() }
        }
    }
    
    fileprivate func reloadAchievementsTable(){
        if(achievementDAO == nil) { achievementDAO = AchievementDao() }
        
        nextUpcoming = achievementDAO.fetchNextAchievement(AppDelegate.getUserInfo()!)
        achievements = achievementDAO.fetchCompletedAchievements(AppDelegate.getUserInfo()!).reversed()
        tableView.reloadData()
    }
    
    @IBAction func settingsAction(_ sender: UIBarButtonItem) {
        (tabBarController as? MainTabBarController)?.displayOptionsMenu(sender)
    }
    
    fileprivate func handleNewAchievementUnlocked() {
        reloadAchievementsTable()
        achievementGotUnlocked = true
    }
    
    fileprivate func showAchievementUnlockedAlert(){
        if let unlocked = achievements.first{
            let alert = UIAlertController(title: unlocked.title, message: unlocked.info, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            achievementGotUnlocked = false
        }
    }
}
