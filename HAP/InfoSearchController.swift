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
        let resultsController = UITableViewController(style: .grouped)
        super.init(searchResultsController: resultsController)
        
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        resultsController.automaticallyAdjustsScrollViewInsets = false
        resultsController.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        
        searchResultsUpdater = self
        searchBar.placeholder = "Informasjonssider"
        //searchBar.setValue("Avbryt", forKey:"_cancelButtonText")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        results = dao.searchHelpInfosTitle(searchController.searchBar.text ?? "")
        (searchResultsController as? UITableViewController)?.tableView.reloadData()
    }
    
    //Tableview operations
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) { cell = UITableViewCell(style: .default, reuseIdentifier: "cell") }
        
        cell!.textLabel?.text = results[(indexPath as NSIndexPath).row].title
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Søkeresultat"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 46 : 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedHelpInfo = results[(indexPath as NSIndexPath).row]
        isActive = false
    }
}
