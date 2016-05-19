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
        SwiftEventBus.onMainThread(eventBusTarget, name: HelpInfoTableController.RELOAD_INFO_EVENT, handler: {[weak self] _ in self?.reloadInfoList()})
        reloadInfoList()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, -30, 0)
        
        searchController = InfoSearchController()
        searchController.delegate = self
        tableView.tableHeaderView = searchController.searchBar
    }
    
    deinit{
        SwiftEventBus.unregister(eventBusTarget)
        searchController.view.removeFromSuperview()
    }
    
    private func reloadInfoList(){
        if helpInfoDao == nil { helpInfoDao = HelpInfoDao() }
        
        helpInfoCategories = helpInfoDao.fetchAllHelpInfoCategories()
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let tableSelection = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(tableSelection, animated: true)
        }
    }
    
    //Tableview operations
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let infoCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HelpInfoCell
            infoCell.contentLabel.text = helpInfoCategories[indexPath.row].title
            return infoCell
        }
        else {
            let actionCell = tableView.dequeueReusableCellWithIdentifier("callerCell", forIndexPath: indexPath) as! HelpInfoActionCell
            actionCell.contentLabel.text = staticButtonsArray[indexPath.row]
            actionCell.contentImage.image = UIImage(named: indexPath.row == 0 ? "callCell" : "chatCell")
            return actionCell
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? helpInfoCategories.count : 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Kategorier" : "Spørsmål og svar"
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 46 : 30
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { performSegueWithIdentifier("helpInfoCategory", sender: self) }
        else if indexPath.row == 0 { return presentCallPromt() }
        else { performSegueWithIdentifier("sendAnonQuestion", sender: nil) }
    }
    
    func presentCallPromt() {
        let alert = UIAlertController(title: "Ring RUStelefonen", message: "Ring for en hyggelig telefonsamtale!", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ring 08588", style: .Default, handler: { action in UIApplication.sharedApplication().openURL(NSURL(string: "tel://08588")!) }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .Cancel, handler: nil))
        
        let indexPath = tableView.indexPathForSelectedRow!
        presentViewController(alert, animated: true, completion: { action in self.tableView.deselectRowAtIndexPath(indexPath, animated: true) })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sendAnonQuestion" { return }
        if segue.identifier == "HelpInfoTrigger" { return }
        if segue.identifier == "brainSearch" { return }
        
        if let dest = segue.destinationViewController as? HelpInfoDetailController{
            dest.helpInfo = searchController.selectedHelpInfo
        }
        else if let dest = segue.destinationViewController as? HelpInfoCategoryController{
            dest.helpInfoCategory = helpInfoCategories[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    @IBAction func displaySettingsMenu(sender: UIBarButtonItem) {
        (tabBarController as? MainTabBarController)?.displayOptionsMenu(sender)
    }
    
    func willPresentSearchController(searchController: UISearchController){
        tabBarController?.tabBar.hidden = true
        self.searchController.selectedHelpInfo = nil
    }
    
    func didDismissSearchController(searchController: UISearchController){
        tabBarController?.tabBar.hidden = false
        if let title = self.searchController.selectedHelpInfo?.title{
            let segId = title.lowercaseString == "3d-hjernen" ? "brainSearch" : "infoSearch"
            performSegueWithIdentifier(segId, sender: nil)
        }
    }
}
