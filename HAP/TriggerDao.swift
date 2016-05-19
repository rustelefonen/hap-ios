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
        triggerEntity = String(Trigger)
        super.init()
    }
    
    //Operations
    
    func createNewTrigger() -> Trigger {
        return NSEntityDescription.insertNewObjectForEntityForName(triggerEntity, inManagedObjectContext: managedObjectContext) as! Trigger
    }
    
    func createNewTrigger(title:String, imageName:String, color:Int64) -> Trigger {
        let newTrigger = createNewTrigger()
        newTrigger.title = title
        newTrigger.imageName = imageName
        newTrigger.color = NSNumber(longLong: color)
        return newTrigger
    }
    
    func getAllTriggers() -> [Trigger] {
        let fetchRequest = NSFetchRequest(entityName: triggerEntity)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let allTriggers = (try? managedObjectContext.executeFetchRequest(fetchRequest)) as? [Trigger]
        
        return allTriggers ?? []
    }
    
    func deleteAll(){
        deleteObjects(getAllTriggers())
    }
}
