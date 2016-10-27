//
//  TriggerDAO.swift
//  HAP
//
//  Created by Simen Fonnes on 01.03.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//
import CoreData

class TriggerDao: CoreDataDao {
    
    //Fields
    let triggerEntity:String
    
    //Constructor
    required init() {
        triggerEntity = String(describing: Trigger.self)
        super.init()
    }
    
    //Operations
    
    func createNewTrigger() -> Trigger {
        return NSEntityDescription.insertNewObject(forEntityName: triggerEntity, into: managedObjectContext) as! Trigger
    }
    
    func createNewTrigger(_ title:String, imageName:String, color:Int64) -> Trigger {
        let newTrigger = createNewTrigger()
        newTrigger.title = title
        newTrigger.imageName = imageName
        newTrigger.color = NSNumber(value: color as Int64)
        return newTrigger
    }
    
    func getAllTriggers() -> [Trigger] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: triggerEntity)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let allTriggers = (try? managedObjectContext.fetch(fetchRequest)) as? [Trigger]
        
        return allTriggers ?? []
    }
    
    func deleteAll(){
        deleteObjects(getAllTriggers())
    }
}
