//
//  AchievementTest.swift
//  HAP
//
//  Created by Simen Fonnes on 05.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest
@testable import HAP

class AchievementTest: XCTestCase {
    
    var achievement:Achievement!
    var achievementDao:AchievementDao!
    var userInfo:UserInfo!
    var userInfoDao:UserInfoDao!
    
    override func setUp() {
        super.setUp()
        achievementDao = AchievementDao()
        achievement = achievementDao.createNewAchievement()
        userInfoDao = UserInfoDao()
        userInfo = userInfoDao.createNewUserInfo()
    }
    
    override func tearDown() {
        super.tearDown()
        achievementDao.delete(achievement)
        userInfoDao.delete(userInfo)
    }
    
    func testIsInCategory() {
        let mileStone = Achievement.Category.Milestone
        achievement.category = mileStone.rawValue
        XCTAssertTrue(achievement.isInCategory(mileStone))
        XCTAssertFalse(achievement.isInCategory(Achievement.Category.Economic))
    }
    
    func testGetProgress() {
        userInfo.moneySpentPerDayOnHash = 100
        userInfo.startDate = Date().dateByAddingTimeInterval(-86400) //Minus one day
        
        let economicAchievement = achievementDao.createNewAchievement("1000 kr Spart!", info: "Du har spart 1000 kr!", pointsRequired: 1000, category: .Economic)
        let minorMilestoneAchievement = achievementDao.createNewAchievement("Første dagen uten!", info: "Du har klart din første dag uten cannabis!", pointsRequired: 86400, category: .MinorMilestone)
        
        achievement.category = ""
        XCTAssertEqual(achievement.getProgress(userInfo), 0.0)
        XCTAssertEqualWithAccuracy(economicAchievement.getProgress(userInfo), 0.1, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(minorMilestoneAchievement.getProgress(userInfo), 1.0, accuracy: 0.1)
    }
    
    func testIsComplete() {
        userInfo.moneySpentPerDayOnHash = 100
        userInfo.startDate = Date().dateByAddingTimeInterval(-86400) //Minus one day
        
        achievement.category = Achievement.Category.Economic.rawValue
        achievement.pointsRequired = 90
        XCTAssertTrue(achievement.isComplete(userInfo))
        
        achievement.pointsRequired = 110
        XCTAssertFalse(achievement.isComplete(userInfo))
    }
    
    func testTimeToCompletion() {
        userInfo.moneySpentPerDayOnHash = 100
        userInfo.startDate = Date().dateByAddingTimeInterval(-86400) //Minus one day
        
        let economicAchievement = achievementDao.createNewAchievement("1000 kr Spart!", info: "Du har spart 1000 kr!", pointsRequired: 1000, category: .Economic)
        let minorMilestoneAchievement = achievementDao.createNewAchievement("Første dagen uten!", info: "Du har klart din første dag uten cannabis!", pointsRequired: 172800, category: .MinorMilestone)
        
        achievement.category = ""
        XCTAssertEqual(achievement.getProgress(userInfo), 0.0)
        XCTAssertEqualWithAccuracy(economicAchievement.timeToCompletion(userInfo), 777600.0, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(minorMilestoneAchievement.timeToCompletion(userInfo), 86400.0, accuracy: 0.1)
    }
    
    func testGetIcon() {
        userInfo.moneySpentPerDayOnHash = 100
        userInfo.startDate = Date().dateByAddingTimeInterval(-86400) //Minus one day
        achievement.category = Achievement.Category.Economic.rawValue
        achievement.pointsRequired = 110
        XCTAssertEqual(UIImagePNGRepresentation(achievement.getIcon(userInfo)), UIImagePNGRepresentation(UIImage(named: "EconomicWhite")!))
        achievement.pointsRequired = 90
        XCTAssertEqual(UIImagePNGRepresentation(achievement.getIcon(userInfo)), UIImagePNGRepresentation(UIImage(named: "Economic")!))
    }

    func testTimeToCompletionIsCalculateable() {
        let categories = Achievement.Category.self
        
        achievement.category = categories.Health.rawValue
        XCTAssertFalse(achievement.timeToCompletionIsCalculateable(userInfo))
        
        achievement.category = categories.Economic.rawValue
        XCTAssertFalse(achievement.timeToCompletionIsCalculateable(userInfo))
        
        userInfo.moneySpentPerDayOnHash = 100
        XCTAssertTrue(achievement.timeToCompletionIsCalculateable(userInfo))
        
        achievement.category = categories.Milestone.rawValue
        XCTAssertTrue(achievement.timeToCompletionIsCalculateable(userInfo))
        
        achievement.category = categories.MinorMilestone.rawValue
        XCTAssertTrue(achievement.timeToCompletionIsCalculateable(userInfo))
    }
}
