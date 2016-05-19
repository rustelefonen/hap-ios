//
//  InfoSearchController.swift
//  HAP
//
//  Created by Fredrik Loberg on 09/05/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class InfoSearchController: UISearchController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var results = [HelpInfo]()
    let dao = HelpInfoDao()
    
    var selectedHelpInfo:HelpInfo?
    
    init() {
        let resultsController = UITableViewController(style: .Grouped)
        super.init(searchResultsController: resultsController)
        
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        resultsController.automaticallyAdjustsScrollViewInsets = false
        resultsController.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        
        searchResultsUpdater = self
        searchBar.placeholder = "Informasjonssider"
        //searchBar.setValue("Avbryt", forKey:"_cancelButtonText")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        results = dao.searchHelpInfosTitle(searchController.searchBar.text ?? "")
        (searchResultsController as? UITableViewController)?.tableView.reloadData()
    }
    
    //Tableview operations
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCellWithIdentifier("cell")
        if (cell == nil) { cell = UITableViewCell(style: .Default, reuseIdentifier: "cell") }
        
        cell!.textLabel?.text = results[indexPath.row].title
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Søkeresultat"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 46 : 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedHelpInfo = results[indexPath.row]
        active = false
    }
}
