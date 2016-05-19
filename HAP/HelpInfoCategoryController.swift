//
//  HelpInfoCategory.swift
//  HAP
//
//  Created by Simen Fonnes on 15.03.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class HelpInfoCategoryController : UITableViewController {
    
    var helpInfoCategory:HelpInfoCategory!
    var helpInfoList = [HelpInfo]()
    
    override func viewDidLoad() {
        helpInfoList = helpInfoCategory.helpInfoSorted()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let tableSelection = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(tableSelection, animated: true)
        }
        
        //object might be updated
        if helpInfoCategory.managedObjectContext == nil {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = helpInfoList[indexPath.row].title
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpInfoList.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if helpInfoList[indexPath.row].title.lowercaseString == "3d-hjernen" { performSegueWithIdentifier("brainSegue", sender: self) }
        else { performSegueWithIdentifier("helpInfoItem", sender: self) }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return helpInfoCategory.title
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 46 : 30
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? HelpInfoDetailController {
            let index = tableView.indexPathForSelectedRow!
            destination.helpInfo = helpInfoList[index.row]
        }
    }
}
