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
        entityName = String(describing: Achievement.self)
        super.init()
    }
    
    //Public operations
    func createNewAchievement() -> Achievement{
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! Achievement
    }
    
    func createNewAchievement(_ title: String, info: String, pointsRequired: Int, category: Achievement.Category) -> Achievement{
        let achievement = createNewAchievement()
        achievement.title = title
        achievement.info = info
        achievement.pointsRequired = NSNumber(value: pointsRequired)
        achievement.category = category.rawValue
        return achievement
    }
    
    func fetchCompletedAchievements(_ userInfo: UserInfo) -> [Achievement] {
        return getAll().filter({$0.timeToCompletionIsCalculateable(userInfo)})
            .sorted(by: {$0.timeToCompletion(userInfo) < $1.timeToCompletion(userInfo)})
            .filter({$0.isComplete(userInfo)})
    }
    
    func fetchIncompletedAchievements(_ userInfo: UserInfo) -> [Achievement] {
        return getAll().sorted(by: {$0.timeToCompletion(userInfo) < $1.timeToCompletion(userInfo)})
            .filter({!$0.isComplete(userInfo)})
    }
    
    func fetchNextAchievement(_ userInfo:UserInfo) -> Achievement? {
        return getAll().filter({$0.timeToCompletionIsCalculateable(userInfo)})
            .sorted(by: {$0.timeToCompletion(userInfo) < $1.timeToCompletion(userInfo)})
            .filter({!$0.isComplete(userInfo)})
            .first
    }
    
    func getAll() -> [Achievement] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let achievements = (try? managedObjectContext.fetch(fetchRequest)) as? [Achievement]
        
        return achievements ?? []
    }
    
    func deleteAll(){
        deleteObjects(getAll())
    }
}
