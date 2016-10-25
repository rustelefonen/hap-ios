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
    
    let preferences = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        minorMilestoneSwitch.isOn = loadMinorMilestoneSetting()
        milestoneSwitch.isOn = loadMilestoneSetting()
        economicSwitch.isOn = loadEconomicSetting()
        healthSwitch.isOn = loadHealthSetting()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 46 : 30
    }
    @IBAction func savePreferences(_ sender: AnyObject) {
        preferences.set(minorMilestoneSwitch.isOn, forKey: SettingsViewController.minorMilestoneSettingKey)
        preferences.set(milestoneSwitch.isOn, forKey: SettingsViewController.milestoneSettingKey)
        preferences.set(economicSwitch.isOn, forKey: SettingsViewController.economicMilestoneSettingKey)
        preferences.set(healthSwitch.isOn, forKey: SettingsViewController.healthSettingKey)
        
        NotificationHandler.scheduleAchievementNotifications(AppDelegate.getUserInfo()!, force: true)
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func cancelSettings(_ sender: AnyObject) {
        if noChangesMade() { navigationController?.popViewController(animated: true) }
        else { showUnSavedChangesNotSavedAlert() }
    }
    
    fileprivate func noChangesMade() -> Bool {
        return minorMilestoneSwitch.isOn == loadMinorMilestoneSetting() &&
            milestoneSwitch.isOn == loadMilestoneSetting() &&
            economicSwitch.isOn == loadEconomicSetting() &&
            healthSwitch.isOn == loadHealthSetting()
    }
    
    fileprivate func showUnSavedChangesNotSavedAlert() {
        let alert = UIAlertController(title: "Ikke lagret!", message: "Du har ikke lagret endringene", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Forkast", style: .destructive, handler: { alert in self.navigationController?.popViewController(animated: true) }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func loadMinorMilestoneSetting() -> Bool {
        return preferences.object(forKey: SettingsViewController.minorMilestoneSettingKey) as? Bool ?? true
    }
    
    fileprivate func loadMilestoneSetting() -> Bool {
        return preferences.object(forKey: SettingsViewController.milestoneSettingKey) as? Bool ?? true
    }
    
    fileprivate func loadEconomicSetting() -> Bool {
        return preferences.object(forKey: SettingsViewController.economicMilestoneSettingKey) as? Bool ?? true
    }
    
    fileprivate func loadHealthSetting() -> Bool {
        return preferences.object(forKey: SettingsViewController.healthSettingKey) as? Bool ?? true
    }
}
