//
//  MainTableViewController.swift
//  HAP
//
//  Created by Simen Fonnes on 19.01.16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit
import CoreData

class HelpInfoTableController: UITableViewController, UISearchControllerDelegate {
    static let RELOAD_INFO_EVENT = "reload_info_event"
    let eventBusTarget = 1
    
    let staticButtonsArray = ["Ring RUStelefonen", "Send anonymt spørsmål"]
    
    //Fields
    var searchController:InfoSearchController!
    var helpInfoDao:HelpInfoDao!
    var helpInfoCategories: [HelpInfoCategory]!
    
    @IBOutlet weak var callCell: UITableViewCell!
    
    //Lifecycle operations
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftEventBus.onMainThread(eventBusTarget as AnyObject, name: HelpInfoTableController.RELOAD_INFO_EVENT, handler: {[weak self] _ in self?.reloadInfoList()})
        reloadInfoList()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, -30, 0)
        
        searchController = InfoSearchController()
        searchController.delegate = self
        tableView.tableHeaderView = searchController.searchBar
    }
    
    deinit{
        SwiftEventBus.unregister(eventBusTarget as AnyObject)
        searchController.view.removeFromSuperview()
    }
    
    fileprivate func reloadInfoList(){
        if helpInfoDao == nil { helpInfoDao = HelpInfoDao() }
        
        helpInfoCategories = helpInfoDao.fetchAllHelpInfoCategories()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tableSelection = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: tableSelection, animated: true)
        }
    }
    
    //Tableview operations
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let infoCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HelpInfoCell
            infoCell.contentLabel.text = helpInfoCategories[(indexPath as NSIndexPath).row].title
            return infoCell
        }
        else {
            let actionCell = tableView.dequeueReusableCell(withIdentifier: "callerCell", for: indexPath) as! HelpInfoActionCell
            actionCell.contentLabel.text = staticButtonsArray[(indexPath as NSIndexPath).row]
            actionCell.contentImage.image = UIImage(named: (indexPath as NSIndexPath).row == 0 ? "callCell" : "chatCell")
            return actionCell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? helpInfoCategories.count : 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Kategorier" : "Spørsmål og svar"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 46 : 30
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((indexPath as NSIndexPath).section == 0) {
            let helpInfoInSelectedCategory = helpInfoCategories[(indexPath as NSIndexPath).row].helpInfo.allObjects
            
            if helpInfoInSelectedCategory.count == 1 {
                let singleHelpInfo = helpInfoInSelectedCategory.first as? HelpInfo
                if singleHelpInfo!.title.lowercased() == "3d-hjernen" {
                    performSegue(withIdentifier: "brainSearch", sender: self)
                } else {
                    performSegue(withIdentifier: "singleHelpInfo", sender: self)
                }
            } else {
                performSegue(withIdentifier: "helpInfoCategory", sender: self)
            }
        } else if ((indexPath as NSIndexPath).section == 1) {
            if (indexPath as NSIndexPath).row == 0 {
                return presentCallPromt()
            } else if ((indexPath as NSIndexPath).row == 1) {
                performSegue(withIdentifier: "sendAnonQuestion", sender: nil)
            }
        }
    }
    
    func presentCallPromt() {
        let alert = UIAlertController(title: "Ring RUStelefonen", message: "Ring for en hyggelig telefonsamtale!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ring 08588", style: .default, handler: { action in UIApplication.shared.openURL(URL(string: "tel://08588")!) }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        
        let indexPath = tableView.indexPathForSelectedRow!
        present(alert, animated: true, completion: { action in self.tableView.deselectRow(at: indexPath, animated: true) })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendAnonQuestion" { return }
        if segue.identifier == "HelpInfoTrigger" { return }
        if segue.identifier == "brainSearch" { return }
        
        if let dest = segue.destination as? HelpInfoDetailController{
            if segue.identifier == "infoSearch" { dest.helpInfo = searchController.selectedHelpInfo }
            else if tableView.indexPathForSelectedRow != nil {
                if helpInfoCategories[(tableView.indexPathForSelectedRow! as NSIndexPath).row].helpInfo.allObjects.count <= 1 {
                    dest.helpInfo = helpInfoCategories[(tableView.indexPathForSelectedRow! as NSIndexPath).row].helpInfo.allObjects.first as? HelpInfo
                }
            }
        }
        else if let dest = segue.destination as? HelpInfoCategoryController{
            dest.helpInfoCategory = helpInfoCategories[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
        }
    }
    
    @IBAction func displaySettingsMenu(_ sender: UIBarButtonItem) {
        (tabBarController as? MainTabBarController)?.displayOptionsMenu(sender)
    }
    
    func willPresentSearchController(_ searchController: UISearchController){
        tabBarController?.tabBar.isHidden = true
        self.searchController.selectedHelpInfo = nil
    }
    
    func didDismissSearchController(_ searchController: UISearchController){
        tabBarController?.tabBar.isHidden = false
        if let title = self.searchController.selectedHelpInfo?.title{
            let segId = title.lowercased() == "3d-hjernen" ? "brainSearch" : "infoSearch"
            performSegue(withIdentifier: segId, sender: nil)
        }
    }
}
