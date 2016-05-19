//
//  CoreDataDao.swift
//  HAP
//
//  Created by Fredrik Loberg on 05/02/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit
import CoreData

class CoreDataDao {
    
    var managedObjectContext:NSManagedObjectContext
    
    required init(){
        managedObjectContext = AppDelegate.getManagedObjectContext()
    }
    
    func save() -> Bool{
        let result:Void? = try? managedObjectContext.save()
        return result == nil ? false : true
    }
    
    func delete(object:NSManagedObject){
        managedObjectContext.deleteObject(object)
    }
    
    func deleteObjects(objects:[NSManagedObject]){
        for o in objects{
            delete(o)
        }
    }
}
