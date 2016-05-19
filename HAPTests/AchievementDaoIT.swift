//
//  AchievementDaoTest.swift
//  HAP
//
//  Created by Simen Fonnes on 05.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest
@testable import HAP

class AchievementDaoIT: TestBase {
    
    var achievementDao:AchievementDao!
    var achievement:Achievement!
    var userInfoDao:UserInfoDao!
    var userInfo:UserInfo!
    
    override func setUp() {
        super.setUp()
        prePopulatedDb()
        achievementDao = AchievementDao()
        userInfoDao = UserInfoDao()
        userInfo = userInfoDao.createNewUserInfo()
        achievementDao.managedObjectContext.reset()
    }
    
    override func tearDown() {
        super.tearDown()
        if achievement != nil {achievementDao.delete(achievement)}
        userInfoDao.delete(userInfo)
    }
    
    func testCreateNewAchievement() {
        achievement = achievementDao.createNewAchievement()
        XCTAssertNotNil(achievement)
    }
    
    func testCreateNewAchievementWithParams() {
        achievement = achievementDao.createNewAchievement("TestAchievement", info: "This is a test achievement", pointsRequired: 100, category: Achievement.Category.Economic)
        XCTAssertNotNil(achievement)
    }
    
    func testFetchCompletedAchievements() {
        userInfo.startDate = NSDate().dateByAddingTimeInterval(-90000) // first step and first day
        XCTAssertEqual(achievementDao.fetchCompletedAchievements(userInfo).count, 2)
    }
    
    func testFetchIncompletedAchievements() {
        userInfo.startDate = NSDate().dateByAddingTimeInterval(-8400) //first step completed
        XCTAssertEqual(achievementDao.fetchIncompletedAchievements(userInfo).count, 29)
    }
    
    func testFetchNextAchievement() {
        userInfo.startDate = NSDate().dateByAddingTimeInterval(-86000)
        XCTAssertEqual(achievementDao.fetchNextAchievement(userInfo)?.title, "Første dagen uten!")
    }
    
    func testGetAll() {
        XCTAssertEqual(achievementDao.getAll().count, 30)
    }
    
    func testDeleteAll() {
        achievementDao.createNewAchievement()
        XCTAssertTrue(achievementDao.getAll().count > 0)
        achievementDao.deleteAll()
        XCTAssertEqual(achievementDao.getAll().count, 0)
    }
}
