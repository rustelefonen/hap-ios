//
//  HAPUITests.swift
//  HAPUITests
//
//  Created by Fredrik Loberg on 26/03/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest

class HAPUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(2)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //Helper functions
    func getRand(count:UInt) -> UInt{
        return UInt(Int(arc4random_uniform(UInt32(count)) + 1))
    }
    
    func getSwitchValue(switcher:XCUIElement) -> Bool {
        return switcher.value as! String == "1"
    }
}
