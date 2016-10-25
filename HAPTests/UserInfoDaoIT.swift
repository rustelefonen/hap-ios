//
//  UserInfoDaoTest.swift
//  HAP
//
//  Created by Simen Fonnes on 05.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest
@testable import HAP

class UserInfoDaoIT: TestBase {
    
    var userInfoDao:UserInfoDao!
    var userInfo:UserInfo!
    
    override func setUp() {
        super.setUp()
        prePopulatedDb()
        userInfoDao = UserInfoDao()
        userInfoDao.managedObjectContext.reset()
    }
    
    override func tearDown() {
        super.tearDown()
        if userInfo != nil {userInfoDao.delete(userInfo)}
    }
    
    func testCreateNewUserInfo() {
        userInfo = userInfoDao.createNewUserInfo()
        XCTAssertNotNil(userInfo)
    }
    
    func testCreateNewUserInfoWithParams() {
        userInfo = userInfoDao.createNewUserInfo("18", gender: "Kvinne", state: "Finnmark", moneySpentPerDayOnHash: 150.0, startDate: Date().dateByAddingTimeInterval(-86400))
        XCTAssertNotNil(userInfo)
    }
    
    func testDeleteAll() {
        userInfoDao.createNewUserInfo()
        XCTAssertNotNil(userInfoDao.fetchUserInfo())
        userInfoDao.deleteAll()
        XCTAssertNil(userInfoDao.fetchUserInfo())
    }
    
    func testFetchUserInfo() {
        userInfo = userInfoDao.createNewUserInfo()
        XCTAssertNotNil(userInfoDao.fetchUserInfo())
    }
    
    func testAddTriggerToUser() {
        userInfo = userInfoDao.createNewUserInfo()
        let trigger = TriggerDao().getAllTriggers().first
        userInfoDao.addTriggerToUser(userInfo, trigger: trigger!, kind: UserTrigger.Kind.Resisted)
        XCTAssertEqual(userInfo.getResistedTriggersAsArray().count, 1)
    }
}
