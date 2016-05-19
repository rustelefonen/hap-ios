//
//  HomeControllerUITest.swift
//  HAP
//
//  Created by Simen Fonnes on 04.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest

class HomeControllerUITest: HAPUITests {
        
    func testSetPriceCalculator() {
        app.scrollViews.otherElements.staticTexts["Start Sparekalkulator"].tap()
        
        app.textFields["150"].tap()
        let deleteKey = app.keys["Delete"]
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        
        app.textFields["Oppgi pris per gram i hele kroner."].typeText("200")
        app.toolbars.buttons["Ferdig"].tap()
        
        //app.scrollViews.pickerWheels.elementBoundByIndex(0).adjustToPickerWheelValue("5")

        
        app.navigationBars["Sparekalkulator"].buttons["Lagre"].tap()
        app.scrollViews.otherElements.staticTexts["Du har spart: 0 kr."].tap()
        
        XCTAssertTrue(app.textFields["200"].exists)
        
    }
}
