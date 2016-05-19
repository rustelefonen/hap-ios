//
//  TestInfo.swift
//  HAP
//
//  Created by Simen Fonnes on 06.04.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

/*
import UIKit

class TestInfo: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Fields
    var helpInfoCategories: [HelpInfoCategory]!
    let cellIdentifier = "cell"
    let accessoryImageName = "redarrow"
    
    @IBOutlet weak var callCell: UITableViewCell!
    
    //Lifecycle operations
    override func viewDidLoad() {
        scrollView.alwaysBounceVertical = true
        ScrollViewUtil.setScrollHeightOf(scrollView)
        super.viewDidLoad()
        let helpInfoDAO = HelpInfoDao()
        helpInfoCategories = helpInfoDAO.fetchAllHelpInfoCategories()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let tableSelection = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(tableSelection, animated: true)
        }
    }
    
    //Tableview operations
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HelpInfoCell
        cell.contentLabel.text = helpInfoCategories[indexPath.row].title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpInfoCategories.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("helpInfoCategory", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "HelpInfoTrigger" {return}
        
        let destination = segue.destinationViewController as! HelpInfoCategoryController
        let index = tableView.indexPathForSelectedRow!
        destination.helpInfoCategory = helpInfoCategories[index.row]
    }
    
    @IBAction func displaySettingsMenu(sender: UIBarButtonItem) {
        if let mainTabController = tabBarController as? MainTabBarController {
            mainTabController.displayOptionsMenu()
        }
    }
}*/
