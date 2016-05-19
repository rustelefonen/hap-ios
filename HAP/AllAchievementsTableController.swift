//
//  ShowAllAchievementsTVC.swift
//  HAP
//
//  Created by Simen Fonnes on 25.04.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class AllAchievementsTableController: UITableViewController {
    
    @IBInspectable var nextUpcomingSectionHeader:String!
    @IBInspectable var completedSectionHeader:String!
    
    //Fields
    var completedAchievements: [Achievement]!
    var incompletedAchievements: [Achievement]!
    var achievementDAO: AchievementDao!
    var timer: NSTimer!
    
    //Lifecycle operations
    override func viewDidLoad() {
        super.viewDidLoad()
        achievementDAO = AchievementDao()
        loadAchievements()
    }
    
    private func loadAchievements(){
        completedAchievements = achievementDAO.fetchCompletedAchievements(AppDelegate.getUserInfo()!).reverse()
        incompletedAchievements = achievementDAO.fetchIncompletedAchievements(AppDelegate.getUserInfo()!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
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
        return section == 0 ? incompletedAchievements.count
        : section == 1 ? completedAchievements.count
        : 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        v.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 30))
        label.text = section == 0 ? nextUpcomingSectionHeader : completedSectionHeader
        
        v.addSubview(label)
        return v
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AchievementCell
        let achievement = indexPath.section == 0 ? incompletedAchievements[indexPath.row] : completedAchievements[indexPath.row]
        
        cell.imageViewContent.image = achievement.getIcon(AppDelegate.getUserInfo()!)
        cell.titleLabel.text = achievement.title
        cell.contentLabel.text = achievement.info
        
        cell.backgroundColor = indexPath.section == 0 ? UIColor.clearColor() : UIColor.whiteColor()
        setProgressOf(cell, achievement: achievement)
        
        return cell
    }
    
    private func setProgressOf(cell: AchievementCell, achievement: Achievement, animated:Bool = false){
        let progress = achievement.getProgress(AppDelegate.getUserInfo()!)
        cell.progressView.setProgress(Float(progress), animated: animated)
    }
    
    func updateProgress(){
        var achievementIsCompleted = false
        
        for (i, achievement) in incompletedAchievements.enumerate() {
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as? AchievementCell{
                setProgressOf(cell, achievement: achievement, animated: true)
                if achievement.isComplete(AppDelegate.getUserInfo()!) { achievementIsCompleted = true }
            }
        }
        
        if achievementIsCompleted { loadAchievements() }
    }
}
