//
//  HelpInfoDaoTest.swift
//  HAP
//
//  Created by Simen Fonnes on 05.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest
@testable import HAP

class HelpInfoDaoIT: TestBase {
    
    var helpInfoDao:HelpInfoDao!
    var helpInfo:HelpInfo!
    var helpInfoCategory:HelpInfoCategory!
    
    override func setUp() {
        super.setUp()
        prePopulatedDb()
        helpInfoDao = HelpInfoDao()
        helpInfoDao.managedObjectContext.reset()
    }
    
    override func tearDown() {
        super.tearDown()
        if helpInfo != nil { helpInfoDao.delete(helpInfo) }
        if helpInfoCategory != nil { helpInfoDao.delete(helpInfoCategory) }
    }
    
    func testCreateNewHelpInfo() {
        helpInfo = helpInfoDao.createNewHelpInfo()
        XCTAssertNotNil(helpInfo)
    }
    
    func testCreateNewHelpInfoWithParams() {
        helpInfo = helpInfoDao.createNewHelpInfo("TestTitle", htmlContent: "TestPath")
        XCTAssertNotNil(helpInfo)
    }
    
    func testCreateNewHelpInfoCategory() {
        helpInfoCategory = helpInfoDao.createNewHelpInfoCategory()
        XCTAssertNotNil(helpInfoCategory)
    }
    
    func testCreateNewHelpInfoCategoryWithParams() {
        helpInfoCategory = helpInfoDao.createNewHelpInfoCategory(1, title: "TestCategory")
        XCTAssertNotNil(helpInfoCategory)
    }
    
    func testFetchAllHelpInfo() {
        let count = helpInfoDao.fetchAllHelpInfo().count
        helpInfo = helpInfoDao.createNewHelpInfo()
        XCTAssertEqual(helpInfoDao.fetchAllHelpInfo().count, count + 1)
        helpInfoDao.delete(helpInfo)
        XCTAssertEqual(helpInfoDao.fetchAllHelpInfo().count, count)
    }
    
    func testFetchAllHelpInfoCategories() {
        let count = helpInfoDao.fetchAllHelpInfoCategories().count
        helpInfoCategory = helpInfoDao.createNewHelpInfoCategory()
        XCTAssertEqual(helpInfoDao.fetchAllHelpInfoCategories().count, count + 1)
        helpInfoDao.delete(helpInfoCategory)
        XCTAssertEqual(helpInfoDao.fetchAllHelpInfoCategories().count, count)
    }
    
    func testDeleteAll() {
        helpInfoDao.createNewHelpInfo()
        XCTAssertTrue(helpInfoDao.fetchAllHelpInfo().count > 0)
        helpInfoDao.deleteAll()
        XCTAssertEqual(helpInfoDao.fetchAllHelpInfo().count, 0)
    }
    
    /*func testShouldNotUpdateDatabase() {
        let helpInfoCategories = helpInfoDao.fetchAllHelpInfoCategories()
        var summaries = getSummaryAsArray()
        for tmp in helpInfoCategories {
            summaries.append(HelpInfoCategory.Summary(id: Int(tmp.categoryId), versionNumber: Int(tmp.versionNumber)))
        }
        XCTAssertFalse(helpInfoDao.shouldUpdateDatabase(summaries))
    }*/
    
    /*func testShouldUpdateDatabaseWithDifferentCount() {
        let helpInfoCategories = helpInfoDao.fetchAllHelpInfoCategories()
        var summaries = getSummaryAsArray()
        for tmp in helpInfoCategories {
            summaries.append(HelpInfoCategory.Summary(id: Int(tmp.categoryId), versionNumber: Int(tmp.versionNumber)))
        }
        summaries.append(HelpInfoCategory.Summary(id: 0, versionNumber: 0))
        XCTAssertTrue(helpInfoDao.shouldUpdateDatabase(summaries))
    }*/
    
    /*func testShouldUpdateDatabaseWithDifferentId() {
        let helpInfoCategories = helpInfoDao.fetchAllHelpInfoCategories()
        print(helpInfoCategories.count)
        var summaries = getSummaryAsArray()
        for tmp in helpInfoCategories {
            summaries.append(HelpInfoCategory.Summary(id: Int(tmp.categoryId), versionNumber: Int(tmp.versionNumber)))
        }
        let lastSummary = summaries.last
        let summaryWithDifferentId = HelpInfoCategory.Summary(id: lastSummary!.id + 1, versionNumber: lastSummary!.versionNumber)
        summaries.insert(summaryWithDifferentId, atIndex: summaries.count-1)
        XCTAssertTrue(helpInfoDao.shouldUpdateDatabase(summaries))
    }*/
    
    /*func testShouldUpdateDatabaseWithDifferentVersionNumber() {
        let helpInfoCategories = helpInfoDao.fetchAllHelpInfoCategories()
        var summaries = getSummaryAsArray()
        for tmp in helpInfoCategories {
            summaries.append(HelpInfoCategory.Summary(id: Int(tmp.categoryId), versionNumber: Int(tmp.versionNumber)))
        }
        let lastSummary = summaries.last
        let summaryWithDifferentId = HelpInfoCategory.Summary(id: lastSummary!.id, versionNumber: lastSummary!.versionNumber + 1)
        summaries.insert(summaryWithDifferentId, atIndex: summaries.count-1)
        XCTAssertTrue(helpInfoDao.shouldUpdateDatabase(summaries))
    }*/
    
    func testFetchHelpInfoByName() {
        let name = "TestInfo"
        helpInfoDao.createNewHelpInfo(name, htmlContent: "Test")
        XCTAssertEqual(helpInfoDao.fetchHelpInfoByName(name)?.title, name)
    }
    
    //Filthy hack
    /*func getSummaryAsArray() -> [HelpInfoCategory.Summary] {
        var summaries = [HelpInfoCategory.Summary(id: 0, versionNumber: 0)]
        summaries.removeAll()
        return summaries
    }*/
}
