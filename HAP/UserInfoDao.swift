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
        entityName = String(describing: UserInfo.self)
        
        super.init()
    }
    
    //Operations
    func fetchUserInfo() -> UserInfo? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.fetchLimit = 1
        return (try! managedObjectContext.fetch(fetchRequest) as! [UserInfo]).first
    }
    
    func addTriggerToUser(_ user:UserInfo, trigger:Trigger, kind:UserTrigger.Kind){
        let triggerIncremented = user.incrementTriggerCountIfTriggerExists(trigger, kind: kind)
        if triggerIncremented { return }
        
        //else making new usertrigger
        let userTrigger = NSEntityDescription.insertNewObject(forEntityName: String(describing: UserTrigger.self), into: managedObjectContext) as! UserTrigger
        
        userTrigger.setUser(user)
        userTrigger.setTrigger(trigger)
        userTrigger.setKind(kind)
    }
    
    func createNewUserInfo() -> UserInfo {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! UserInfo
    }
    
    func createNewUserInfo(_ age: String?, gender: String?, state: String?, userType: String?, moneySpentPerDayOnHash: Float, startDate: Date) -> UserInfo{
        let userInfo = createNewUserInfo()
        userInfo.age = age
        userInfo.gender = gender
        userInfo.geoState = state
        userInfo.userType = userType
        userInfo.moneySpentPerDayOnHash = NSNumber(value: moneySpentPerDayOnHash)
        userInfo.startDate = startDate
        return userInfo
    }
    
    func deleteAll(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let userInfos = (try? managedObjectContext.fetch(fetchRequest)) as? [UserInfo] ?? []
        
        deleteObjects(userInfos)
    }
}
