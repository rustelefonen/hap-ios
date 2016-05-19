//
//  IntroControllerUITest.swift
//  HAP
//
//  Created by Simen Fonnes on 04.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest

class IntroControllerUITest: HAPUITests {
        
    func testSendUserData() {
        slideToLastPage()
        
        app.switches["0"].tap()
        
        app.textFields["Alder"].tap()
        app.pickerWheels.element.adjustToPickerWheelValue("18")
        let chooseButton = app.toolbars.buttons["Velg"]
        chooseButton.tap()
        
        app.textFields["Kjønn"].tap()
        app.pickerWheels.element.adjustToPickerWheelValue("Kvinne")
        chooseButton.tap()
        
        app.textFields["Fylke"].tap()
        app.pickerWheels.element.adjustToPickerWheelValue("Aust-Agder")
        chooseButton.tap()
        
        app.buttons["Start appen nå"].tap()
    }
    
    func testDontSendUserData() {
        slideToLastPage()
        app.buttons["Nei takk, start appen nå."].tap()
    }
    
    func testSetDateBefore2000() {
        slideToPickerPage()
        app.pickerWheels.elementBoundByIndex(2).adjustToPickerWheelValue("1967")
        XCTAssertEqual("January", app.pickerWheels.elementBoundByIndex(0).value as? String)
        XCTAssertEqual("1", app.pickerWheels.elementBoundByIndex(1).value as? String)
        XCTAssertEqual("2000", app.pickerWheels.elementBoundByIndex(2).value as? String)
    }
    
    func testSetDateAfter2100() {
        slideToPickerPage()
        app.pickerWheels.elementBoundByIndex(2).adjustToPickerWheelValue("2167")
        
        sleep(4)    //Long scroll
        
        XCTAssertEqual("December", app.pickerWheels.elementBoundByIndex(0).value as? String)
        XCTAssertEqual("31", app.pickerWheels.elementBoundByIndex(1).value as? String)
        XCTAssertEqual("2100", app.pickerWheels.elementBoundByIndex(2).value as? String)
    }
    
    func testAllElementsHaveBeenAddedToFirstView() {
        XCTAssertTrue(app.staticTexts["Velkommen til HAP"].exists)
        XCTAssertTrue(app.images["swipeleft"].exists)
        XCTAssertTrue(app.pageIndicators["side 1 av 4"].exists)
    }
    
    func testAllElementsHaveBeenAddedToSecondView() {
        app.otherElements.containingType(.PageIndicator, identifier:"side 1 av 4").childrenMatchingType(.Other).element.swipeLeft()
        XCTAssertTrue(app.staticTexts["Litt informasjon"].exists)
        XCTAssertTrue(app.pageIndicators["side 2 av 4"].exists)
    }
    
    func testAllElementsHaveBeenAddedToThirdView() {
        slideToPickerPage()
        XCTAssertTrue(app.staticTexts["Velg startdato"].exists)
        XCTAssertTrue(app.staticTexts["Velg dato for når du vil starte programmet"].exists)
        
        XCTAssertTrue(app.pickerWheels.elementBoundByIndex(0).exists)
        XCTAssertTrue(app.pickerWheels.elementBoundByIndex(1).exists)
        XCTAssertTrue(app.pickerWheels.elementBoundByIndex(2).exists)
        
        XCTAssertTrue(app.pageIndicators["side 3 av 4"].exists)
    }
    
    func testAllElementsHaveBeenAddedToFourthView() {
        slideToLastPage()
        XCTAssertTrue(app.staticTexts["Vil du bidra til å forbedre vårt hjelpetilbud?"].exists)
        XCTAssertTrue(app.scrollViews.childrenMatchingType(.TextView).element.exists)
        XCTAssertTrue(app.staticTexts["Jeg ønsker å bidra:"].exists)
        XCTAssertTrue(app.switches["0"].exists)
    }
    
    func slideToLastPage() {
        slideToPickerPage()
        app.otherElements.containingType(.PageIndicator, identifier:"side 3 av 4").childrenMatchingType(.Other).element.swipeLeft()
    }
    
    func slideToPickerPage() {
        let notificationsAlert = app.alerts["“HAP” Would Like to Send You Notifications"].collectionViews.buttons["OK"]
        if notificationsAlert.exists {notificationsAlert.tap()}
        app.otherElements.containingType(.PageIndicator, identifier:"side 1 av 4").childrenMatchingType(.Other).element.swipeLeft()
        app.otherElements.containingType(.PageIndicator, identifier:"side 2 av 4").childrenMatchingType(.Other).element.swipeLeft()
    }
}