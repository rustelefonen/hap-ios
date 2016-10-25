//
//  CountyController.swift
//  HAP
//
//  Created by Fredrik Loberg on 07/04/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class CountyController: UITableViewController {
    
    var counties:[String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        counties = ResourceList.counties
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = counties[(indexPath as NSIndexPath).row]
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return counties.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
    }
}
