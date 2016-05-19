//
//  RemoteInfoDataSourceTest.swift
//  HAP
//
//  Created by Simen Fonnes on 06.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest
@testable import HAP

class RemoteInfoDataSourceTest: XCTestCase {
    
    var helpInfoDao:HelpInfoDao!

    override func setUp() {
        helpInfoDao = HelpInfoDao()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHandleCategoriesFromServerWithNoData() {
        let helpInfoCategoriesBeforeServerCall = helpInfoDao.fetchAllHelpInfoCategories()
        //RemoteInfoDataSource.handleCategoriesFromServer(nil)
        XCTAssertEqual(helpInfoDao.fetchAllHelpInfoCategories(), helpInfoCategoriesBeforeServerCall)
    }
    
    func testHandleCategoriesFromServerWithInvalidJson() {
        let invalidJsonString:NSString = "njkfgdsjkngfskbhfgsjnklgsfjkbgfs15dfg468dfg135fgd48dfg456fghd47dfgs645bg47gr456dfg798ghd465ghr47dfh46fghd47dfg468dfh48fdh47dgh468hdf468dfh468"
        let helpInfoCategoriesBeforeServerCall = helpInfoDao.fetchAllHelpInfoCategories()
        //RemoteInfoDataSource.handleCategoriesFromServer(invalidJsonString.dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(helpInfoDao.fetchAllHelpInfoCategories(), helpInfoCategoriesBeforeServerCall)
        
    }
    
    func testHandleCategoriesFromServerWithValidJson() {
        let jsonString:NSString = "{id = 101;info =();orderNumber = 11;title = \"TestTittel\";versionNumber = 3;}"
        let helpInfoCategoriesBeforeServerCall = helpInfoDao.fetchAllHelpInfoCategories()
        //RemoteInfoDataSource.handleCategoriesFromServer(jsonString.dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertNotEqual(helpInfoDao.fetchAllHelpInfoCategories(), helpInfoCategoriesBeforeServerCall)
    }
}
