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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tableSelection = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: tableSelection, animated: true)
        }
        
        //object might be updated
        if helpInfoCategory.managedObjectContext == nil {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = helpInfoList[(indexPath as NSIndexPath).row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpInfoList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if helpInfoList[(indexPath as NSIndexPath).row].title.lowercased() == "3d-hjernen" { performSegue(withIdentifier: "brainSegue", sender: self) }
        else { performSegue(withIdentifier: "helpInfoItem", sender: self) }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return helpInfoCategory.title
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 46 : 30
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? HelpInfoDetailController {
            let index = tableView.indexPathForSelectedRow!
            destination.helpInfo = helpInfoList[(index as NSIndexPath).row]
        }
    }
}
