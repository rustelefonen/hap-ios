//
//  TriggerDaoTest.swift
//  HAP
//
//  Created by Simen Fonnes on 05.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest
@testable import HAP

class TriggerDaoIT: TestBase {
    
    var triggerDao:TriggerDao!
    var trigger:Trigger!
    
    override func setUp() {
        super.setUp()
        prePopulatedDb()
        triggerDao = TriggerDao()
        triggerDao.managedObjectContext.reset()
    }
    
    override func tearDown() {
        super.tearDown()
        if trigger != nil {triggerDao.delete(trigger)}
    }
    
    func testInit() {
        XCTAssertEqual(triggerDao.triggerEntity, "Trigger")
    }
    
    func testCreateNewTrigger() {
        trigger = triggerDao.createNewTrigger()
        XCTAssertNotNil(trigger)
    }
    
    func testCreateNewTriggerWithParams() {
        trigger = triggerDao.createNewTrigger("TestTrigger", imageName: "Anger", color: 0xc03145FF)
        XCTAssertNotNil(trigger)
    }
    
    func testGetAllTriggers() {
        XCTAssertEqual(triggerDao.getAllTriggers().count, 41)
    }
    
    func testDeleteAll() {
        XCTAssertTrue(triggerDao.getAllTriggers().count > 0)
        triggerDao.deleteAll()
        XCTAssertEqual(triggerDao.getAllTriggers().count, 0)
    }
}
