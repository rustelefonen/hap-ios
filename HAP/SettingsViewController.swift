//
//  SettingsViewController.swift
//  HAP
//
//  Created by Simen Fonnes on 23.02.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    static let storyboardId = "settings"
    
    static let minorMilestoneSettingKey = "minorMilestoneSettingKey"
    static let milestoneSettingKey = "milestoneSettingKey"
    static let economicMilestoneSettingKey = "economicSettingKey"
    static let healthSettingKey = "healthSettingKey"
    
    @IBOutlet weak var minorMilestoneSwitch: UISwitch!
    @IBOutlet weak var milestoneSwitch: UISwitch!
    @IBOutlet weak var economicSwitch: UISwitch!
    @IBOutlet weak var healthSwitch: UISwitch!
    
    let preferences = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        minorMilestoneSwitch.on = loadMinorMilestoneSetting()
        milestoneSwitch.on = loadMilestoneSetting()
        economicSwitch.on = loadEconomicSetting()
        healthSwitch.on = loadHealthSetting()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 46 : 30
    }
    @IBAction func savePreferences(sender: AnyObject) {
        preferences.setBool(minorMilestoneSwitch.on, forKey: SettingsViewController.minorMilestoneSettingKey)
        preferences.setBool(milestoneSwitch.on, forKey: SettingsViewController.milestoneSettingKey)
        preferences.setBool(economicSwitch.on, forKey: SettingsViewController.economicMilestoneSettingKey)
        preferences.setBool(healthSwitch.on, forKey: SettingsViewController.healthSettingKey)
        
        NotificationHandler.scheduleAchievementNotifications(AppDelegate.getUserInfo()!, force: true)
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func cancelSettings(sender: AnyObject) {
        if noChangesMade() { navigationController?.popViewControllerAnimated(true) }
        else { showUnSavedChangesNotSavedAlert() }
    }
    
    private func noChangesMade() -> Bool {
        return minorMilestoneSwitch.on == loadMinorMilestoneSetting() &&
            milestoneSwitch.on == loadMilestoneSetting() &&
            economicSwitch.on == loadEconomicSetting() &&
            healthSwitch.on == loadHealthSetting()
    }
    
    private func showUnSavedChangesNotSavedAlert() {
        let alert = UIAlertController(title: "Ikke lagret!", message: "Du har ikke lagret endringene", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Forkast", style: .Destructive, handler: { alert in self.navigationController?.popViewControllerAnimated(true) }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func loadMinorMilestoneSetting() -> Bool {
        return preferences.objectForKey(SettingsViewController.minorMilestoneSettingKey) as? Bool ?? true
    }
    
    private func loadMilestoneSetting() -> Bool {
        return preferences.objectForKey(SettingsViewController.milestoneSettingKey) as? Bool ?? true
    }
    
    private func loadEconomicSetting() -> Bool {
        return preferences.objectForKey(SettingsViewController.economicMilestoneSettingKey) as? Bool ?? true
    }
    
    private func loadHealthSetting() -> Bool {
        return preferences.objectForKey(SettingsViewController.healthSettingKey) as? Bool ?? true
    }
}
