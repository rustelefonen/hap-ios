//
//  UserInfoDAO.swift
//  HAP
//
//  Created by Simen Fonnes on 03.02.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import CoreData
import UIKit

class UserInfoDao: CoreDataDao {
    
    //Fields
    let entityName:String
    
    //Constructor
    required init() {
        entityName = String(UserInfo)
        super.init()
    }
    
    //Operations
    func fetchUserInfo() -> UserInfo? {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.fetchLimit = 1
        return (try! managedObjectContext.executeFetchRequest(fetchRequest) as! [UserInfo]).first
    }
    
    func addTriggerToUser(user:UserInfo, trigger:Trigger, kind:UserTrigger.Kind){
        let triggerIncremented = user.incrementTriggerCountIfTriggerExists(trigger, kind: kind)
        if triggerIncremented { return }
        
        //else making new usertrigger
        let userTrigger = NSEntityDescription.insertNewObjectForEntityForName(String(UserTrigger), inManagedObjectContext: managedObjectContext) as! UserTrigger
        
        userTrigger.setUser(user)
        userTrigger.setTrigger(trigger)
        userTrigger.setKind(kind)
    }
    
    func createNewUserInfo() -> UserInfo {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext) as! UserInfo
    }
    
    func createNewUserInfo(age: String?, gender: String?, state: String?, moneySpentPerDayOnHash: Float, startDate: NSDate) -> UserInfo{
        let userInfo = createNewUserInfo()
        userInfo.age = age
        userInfo.gender = gender
        userInfo.geoState = state
        userInfo.moneySpentPerDayOnHash = moneySpentPerDayOnHash
        userInfo.startDate = startDate
        return userInfo
    }
    
    func deleteAll(){
        let fetchRequest = NSFetchRequest(entityName: entityName)
        let userInfos = (try? managedObjectContext.executeFetchRequest(fetchRequest)) as? [UserInfo] ?? []
        
        deleteObjects(userInfos)
    }
}