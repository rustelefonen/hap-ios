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
        helpInfoEntity = String(describing: HelpInfo.self)
        helpInfoCategoryEntity = String(describing: HelpInfoCategory.self)
        super.init()
    }
    
    //Operations
    func createNewHelpInfo() -> HelpInfo {
        return NSEntityDescription.insertNewObject(forEntityName: helpInfoEntity, into: managedObjectContext) as! HelpInfo
    }
    
    func createNewHelpInfo(_ title: String, htmlContent: String) -> HelpInfo{
        let newHelpInfo = createNewHelpInfo()
        newHelpInfo.title = title
        newHelpInfo.htmlContent = htmlContent
        return newHelpInfo
    }
    
    func createNewHelpInfoCategory() -> HelpInfoCategory {
        return NSEntityDescription.insertNewObject(forEntityName: helpInfoCategoryEntity, into: managedObjectContext) as! HelpInfoCategory
    }
    
    func createNewHelpInfoCategory(_ order: Int, title: String) -> HelpInfoCategory {
        let category = createNewHelpInfoCategory()
        category.order = NSNumber(value: order)
        category.title = title
        return category
    }
    
    func fetchAllHelpInfo() -> [HelpInfo] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: helpInfoEntity)
        let allHelpInfo = (try? managedObjectContext.fetch(fetchRequest)) as? [HelpInfo]
        
        return allHelpInfo ?? []
    }
    
    func fetchAllHelpInfoCategories() -> [HelpInfoCategory] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: helpInfoCategoryEntity)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        let allCategories = (try? managedObjectContext.fetch(fetchRequest)) as? [HelpInfoCategory]
        
        return allCategories ?? []
    }
    
    func fetchCategoryById(_ id:Int) ->HelpInfoCategory? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: helpInfoCategoryEntity)
        fetchRequest.predicate = NSPredicate(format: "categoryId == %@", String(id))
        return (try? managedObjectContext.fetch(fetchRequest)[0]) as? HelpInfoCategory
    }
    
    func deleteAll(){
        deleteObjects(fetchAllHelpInfoCategories())
        deleteObjects(fetchAllHelpInfo())
    }
    
    func shouldUpdateDatabase(_ summaries: [HelpInfoCategory.Summary]) -> Bool {
        var helpInfoCategories = fetchAllHelpInfoCategories()
        if summaries.count != helpInfoCategories.count { return true }
            
        helpInfoCategories = helpInfoCategories.sorted(by: {$0.categoryId.int32Value < $1.categoryId.int32Value})
        let summariesSorted = summaries.sorted(by: {$0.id < $1.id})
        
        for (i, summary) in summariesSorted.enumerated(){
            if Int32(summary.id) != helpInfoCategories[i].categoryId.int32Value { return true }
            if Int32(summary.versionNumber) != helpInfoCategories[i].versionNumber.int32Value { return true }
        }
        
        return false
    }
    
    func fetchHelpInfoByName(_ name:String) -> HelpInfo? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: helpInfoEntity)
        fetchRequest.predicate = NSPredicate(format: "title LIKE %@", name)
        return (try? managedObjectContext.fetch(fetchRequest)[0]) as? HelpInfo
        //return (try? managedObjectContext.fetch(fetchRequest).first) as? HelpInfo
    }
    
    func searchHelpInfosTitle(_ value:String) -> [HelpInfo]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: helpInfoCategoryEntity)
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", value)
        return (try? managedObjectContext.fetch(fetchRequest)) as? [HelpInfo] ?? []
    }
}
