//
//  AchievementDAO.swift
//  HAP
//
//  Created by Simen Fonnes on 03.02.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import CoreData

class AchievementDao: CoreDataDao {
    
    //Fields
    let entityName:String
    
    //Constructor
    required init() {
        entityName = String(Achievement)
        super.init()
    }
    
    //Public operations
    func createNewAchievement() -> Achievement{
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext) as! Achievement
    }
    
    func createNewAchievement(title: String, info: String, pointsRequired: Int, category: Achievement.Category) -> Achievement{
        let achievement = createNewAchievement()
        achievement.title = title
        achievement.info = info
        achievement.pointsRequired = pointsRequired
        achievement.category = category.rawValue
        return achievement
    }
    
    func fetchCompletedAchievements(userInfo: UserInfo) -> [Achievement] {
        return getAll().filter({$0.timeToCompletionIsCalculateable(userInfo)})
            .sort({$0.timeToCompletion(userInfo) < $1.timeToCompletion(userInfo)})
            .filter({$0.isComplete(userInfo)})
    }
    
    func fetchIncompletedAchievements(userInfo: UserInfo) -> [Achievement] {
        return getAll().sort({$0.timeToCompletion(userInfo) < $1.timeToCompletion(userInfo)})
            .filter({!$0.isComplete(userInfo)})
    }
    
    func fetchNextAchievement(userInfo:UserInfo) -> Achievement? {
        return getAll().filter({$0.timeToCompletionIsCalculateable(userInfo)})
            .sort({$0.timeToCompletion(userInfo) < $1.timeToCompletion(userInfo)})
            .filter({!$0.isComplete(userInfo)})
            .first
    }
    
    func getAll() -> [Achievement] {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        let achievements = (try? managedObjectContext.executeFetchRequest(fetchRequest)) as? [Achievement]
        
        return achievements ?? []
    }
    
    func deleteAll(){
        deleteObjects(getAll())
    }
}
