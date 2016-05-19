//
//  AppDelegateTest.swift
//  HAP
//
//  Created by Simen Fonnes on 05.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest
@testable import HAP

class AppDelegateTest: TestBase {
    
    override func setUp() {
        super.setUp()
        prePopulatedDb()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetManagedObjectContext() {
        XCTAssertNotNil(AppDelegate.getManagedObjectContext())
    }
    
    func testInitUserInfo() {
        UserInfoDao().createNewUserInfo()
        AppDelegate.initUserInfo()
        XCTAssertNotNil(AppDelegate.getUserInfo())
    }
    
    func testGetAppDelegate() {
        XCTAssertNotNil(AppDelegate.getAppDelegate())
    }
}
