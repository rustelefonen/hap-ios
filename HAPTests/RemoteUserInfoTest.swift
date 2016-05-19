//
//  RemoteUserInfoTest.swift
//  HAP
//
//  Created by Simen Fonnes on 06.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest
@testable import HAP

class RemoteUserInfoTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPostDataToServer() {
        RemoteUserInfo.postDataToServer("18", gender: "FEMALE", county: "Finnmark")
        XCTAssertTrue(RemoteUserInfo.loadHasSentResearch())
    }

    func testLoadHasSentResearch() {
        XCTAssertFalse(RemoteUserInfo.loadHasSentResearch())
    }
}
