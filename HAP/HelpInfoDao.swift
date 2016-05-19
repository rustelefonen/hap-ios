//
//  HelpInfoDAO.swift
//  HAP
//
//  Created by Simen Fonnes on 03.02.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit
import CoreData

class HelpInfoDao: CoreDataDao {
    
    //Fields
    let helpInfoEntity:String
    let helpInfoCategoryEntity:String
    
    //Constructor
    required init() {
        helpInfoEntity = String(HelpInfo)
        helpInfoCategoryEntity = String(HelpInfoCategory)
        super.init()
    }
    
    //Operations
    func createNewHelpInfo() -> HelpInfo {
        return NSEntityDescription.insertNewObjectForEntityForName(helpInfoEntity, inManagedObjectContext: managedObjectContext) as! HelpInfo
    }
    
    func createNewHelpInfo(title: String, htmlContent: String) -> HelpInfo{
        let newHelpInfo = createNewHelpInfo()
        newHelpInfo.title = title
        newHelpInfo.htmlContent = htmlContent
        return newHelpInfo
    }
    
    func createNewHelpInfoCategory() -> HelpInfoCategory {
        return NSEntityDescription.insertNewObjectForEntityForName(helpInfoCategoryEntity, inManagedObjectContext: managedObjectContext) as! HelpInfoCategory
    }
    
    func createNewHelpInfoCategory(order: Int, title: String) -> HelpInfoCategory {
        let category = createNewHelpInfoCategory()
        category.order = order
        category.title = title
        return category
    }
    
    func fetchAllHelpInfo() -> [HelpInfo] {
        let fetchRequest = NSFetchRequest(entityName: helpInfoEntity)
        let allHelpInfo = (try? managedObjectContext.executeFetchRequest(fetchRequest)) as? [HelpInfo]
        
        return allHelpInfo ?? []
    }
    
    func fetchAllHelpInfoCategories() -> [HelpInfoCategory] {
        let fetchRequest = NSFetchRequest(entityName: helpInfoCategoryEntity)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        let allCategories = (try? managedObjectContext.executeFetchRequest(fetchRequest)) as? [HelpInfoCategory]
        
        return allCategories ?? []
    }
    
    func fetchCategoryById(id:Int) ->HelpInfoCategory? {
        let fetchRequest = NSFetchRequest(entityName: helpInfoCategoryEntity)
        fetchRequest.predicate = NSPredicate(format: "categoryId == %@", String(id))
        return (try? managedObjectContext.executeFetchRequest(fetchRequest).first) as? HelpInfoCategory
    }
    
    func deleteAll(){
        deleteObjects(fetchAllHelpInfoCategories())
        deleteObjects(fetchAllHelpInfo())
    }
    
    func shouldUpdateDatabase(summaries: [HelpInfoCategory.Summary]) -> Bool {
        var helpInfoCategories = fetchAllHelpInfoCategories()
        if summaries.count != helpInfoCategories.count { return true }
            
        helpInfoCategories = helpInfoCategories.sort({$0.categoryId.intValue < $1.categoryId.intValue})
        let summariesSorted = summaries.sort({$0.id < $1.id})
        
        for (i, summary) in summariesSorted.enumerate(){
            if Int32(summary.id) != helpInfoCategories[i].categoryId.intValue { return true }
            if Int32(summary.versionNumber) != helpInfoCategories[i].versionNumber.intValue { return true }
        }
        
        return false
    }
    
    func fetchHelpInfoByName(name:String) -> HelpInfo? {
        let fetchRequest = NSFetchRequest(entityName: helpInfoEntity)
        fetchRequest.predicate = NSPredicate(format: "title LIKE %@", name)
        return (try? managedObjectContext.executeFetchRequest(fetchRequest).first) as? HelpInfo
    }
    
    func searchHelpInfosTitle(value:String) -> [HelpInfo]{
        let fetchRequest = NSFetchRequest(entityName: helpInfoEntity)
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", value)
        return (try? managedObjectContext.executeFetchRequest(fetchRequest)) as? [HelpInfo] ?? []
    }
}
