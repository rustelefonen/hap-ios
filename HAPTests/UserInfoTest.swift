//
//  UserInfoDaoTest.swift
//  HAP
//
//  Created by Simen Fonnes on 05.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest
@testable import HAP

class UserInfoTest: TestBase {
    
    var userInfo:UserInfo!
    var userInfoDao:UserInfoDao!
    
    override func setUp() {
        super.setUp()
        userInfoDao = UserInfoDao()
        userInfo = userInfoDao.createNewUserInfo()
    }
    
    override func tearDown() {
        super.tearDown()
        userInfoDao.delete(userInfo)
    }
    
    func testTimeInSecondsSinceStarted() {
        userInfo.startDate = Date().dateByAddingTimeInterval(-60) //Minus one minute
        XCTAssertEqualWithAccuracy(userInfo.timeInSecondsSinceStarted(), 60.0, accuracy: 0.001)
    }
    
    func testDaysSinceStarted() {
        userInfo.startDate = Date().dateByAddingTimeInterval(-110000) //Minus one day and four hours, because day turns at 4 am
        XCTAssertEqual(userInfo.daysSinceStarted(), 1)
    }
    
    func testTotalMoneySaved() {
        userInfo.moneySpentPerDayOnHash = 100
        userInfo.startDate = Date().dateByAddingTimeInterval(-86400)
        XCTAssertEqualWithAccuracy(userInfo.totalMoneySaved(), 100.0, accuracy: 0.0001)
    }
    
    func testTotalMoneySavedBeforeReset() {
        userInfo.moneySpentPerDayOnHash = 100
        userInfo.secondsLastedBeforeLastReset = 86400
        XCTAssertEqualWithAccuracy(userInfo.totalMoneySavedBeforeReset(), 100.0, accuracy: 0.0001)
    }
    
    func testMoneySavedPerSecond() {
        userInfo.moneySpentPerDayOnHash = 100
        XCTAssertEqualWithAccuracy(userInfo.moneySavedPerSecond(), 0.0011, accuracy: 0.0001)
    }
    
    func testGetResistedTriggersAsArray() {
        let trigger = TriggerDao().getAllTriggers().first
        userInfoDao.addTriggerToUser(userInfo, trigger: trigger!, kind: .Resisted)
        let resistedTriggers = userInfo.getResistedTriggersAsArray()
        XCTAssertTrue(resistedTriggers.count == 1)
        XCTAssertTrue(resistedTriggers.first!.getTrigger() == trigger)
    }
    
    func testGetSmokedTriggersAsArray() {
        let trigger = TriggerDao().getAllTriggers().first
        userInfoDao.addTriggerToUser(userInfo, trigger: trigger!, kind: .Smoked)
        let smokedTriggers = userInfo.getSmokedTriggersAsArray()
        XCTAssertTrue(smokedTriggers.count == 1)
        XCTAssertTrue(smokedTriggers.first?.getTrigger() == trigger)
    }
    
    func testIncrementTriggerCountIfTriggerExists() {
        let trigger = TriggerDao().getAllTriggers().first
        userInfoDao.addTriggerToUser(userInfo, trigger: trigger!, kind: .Resisted)
        userInfoDao.addTriggerToUser(userInfo, trigger: trigger!, kind: .Resisted)
        let resistedTriggers = userInfo.getResistedTriggersAsArray()
        XCTAssertTrue(resistedTriggers.count == 1)
        XCTAssertTrue(resistedTriggers.first!.count == 2)
    }
}
