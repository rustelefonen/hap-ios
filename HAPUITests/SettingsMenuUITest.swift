//
//  SettingsMenuUITest.swift
//  HAP
//
//  Created by Simen Fonnes on 04.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest

class SettingsMenuUITest: HAPUITests {
    
    private let HOME = "Hjem"
        
    func testResetPosTriggers() {
        app.navigationBars[HOME].buttons["settings"].tap()
        app.sheets.collectionViews.buttons["Tilbakestilling"].tap()
        app.tables.staticTexts["Tilbakestill positive triggere"].tap()
        app.alerts["Tilbakestill positive triggere"].collectionViews.buttons["Tilbakestill"].tap()
    }
    
    func testResetNegTriggers() {
        app.navigationBars[HOME].buttons["settings"].tap()
        app.sheets.collectionViews.buttons["Tilbakestilling"].tap()
        app.tables.staticTexts["Tilbakestill negative triggere"].tap()
        app.alerts["Tilbakestill negative triggere"].collectionViews.buttons["Tilbakestill"].tap()
    }
    
    func testResetClock() {
        app.navigationBars["Hjem"].buttons["settings"].tap()
        app.sheets.collectionViews.buttons["Tilbakestilling"].tap()
        app.tables.staticTexts["Tilbakestill klokken"].tap()
        app.alerts["Tilbakestill klokken"].collectionViews.buttons["Tilbakestill bare klokken"].tap()
        
        sleep(2)
        
        checkIfClockWasReset(app.scrollViews.otherElements.containingType(.StaticText, identifier:"Tid siden du startet programmet").childrenMatchingType(.Other).element)
    }
    
    func testResetClockAndAchievements() {
        app.navigationBars["Hjem"].buttons["settings"].tap()
        app.sheets.collectionViews.buttons["Tilbakestilling"].tap()
        app.tables.staticTexts["Tilbakestill klokken"].tap()
        app.alerts["Tilbakestill klokken"].collectionViews.buttons["Tilbakestill klokken og prestasjoner"].tap()
        
        sleep(2)
        
        checkIfClockWasReset(app.scrollViews.otherElements.containingType(.StaticText, identifier:"Tid siden du startet programmet").childrenMatchingType(.Other).element)
        
        app.tabBars.buttons["Prestasjoner"].tap()
        XCTAssertTrue(app.tables.cells.count == 2)
        
    }
    
    func testDeclineSettingsMenu() {
        app.navigationBars["Hjem"].buttons["settings"].tap()
        app.sheets.buttons["Avbryt"].tap()
    }
    
    func testSettingsMenuAppears() {
        XCTAssertFalse(app.sheets.buttons["Om Applikasjonen"].exists)
        XCTAssertFalse(app.sheets.buttons["Varslingsinnstillinger"].exists)
        XCTAssertFalse(app.sheets.buttons["Tilbakestilling"].exists)
        XCTAssertFalse(app.sheets.buttons["Avbryt"].exists)
        app.navigationBars["Hjem"].buttons["settings"].tap()
        XCTAssertTrue(app.sheets.buttons["Om Applikasjonen"].exists)
        XCTAssertTrue(app.sheets.buttons["Varslingsinnstillinger"].exists)
        XCTAssertTrue(app.sheets.buttons["Tilbakestilling"].exists)
        XCTAssertTrue(app.sheets.buttons["Avbryt"].exists)
    }
    
    func testAboutApplication() {
        app.navigationBars["Hjem"].buttons["settings"].tap()
        app.sheets.collectionViews.buttons["Om Applikasjonen"].tap()
        sleep(2) //Long segue
        XCTAssertTrue(app.staticTexts["Om Applikasjonen"].exists)
    }
    
    func testTurnAllNotificationsOff() {
        let settingsButton = app.navigationBars["Hjem"].buttons["settings"]
        settingsButton.tap()
        
        let varslingsinnstillingerButton = app.sheets.collectionViews.buttons["Varslingsinnstillinger"]
        varslingsinnstillingerButton.tap()
        
        let tablesQuery = app.tables
        tablesQuery.switches["Små milepæler"].tap()
        tablesQuery.switches["Store milepæler"].tap()
        tablesQuery.switches["Økonomiske prestasjoner"].tap()
        tablesQuery.switches["Helseprestasjoner"].tap()
        
        let small = getSwitchValue(tablesQuery.switches["Små milepæler"])
        let big = getSwitchValue(tablesQuery.switches["Store milepæler"])
        let economic = getSwitchValue(tablesQuery.switches["Økonomiske prestasjoner"])
        let health = getSwitchValue(tablesQuery.switches["Helseprestasjoner"])
        
        app.navigationBars["Varslingsinnstillinger"].buttons["Lagre"].tap()
        settingsButton.tap()
        varslingsinnstillingerButton.tap()
        
        XCTAssertEqual(getSwitchValue(tablesQuery.switches["Små milepæler"]), small)
        XCTAssertEqual(getSwitchValue(tablesQuery.switches["Store milepæler"]), big)
        XCTAssertEqual(getSwitchValue(tablesQuery.switches["Økonomiske prestasjoner"]), economic)
        XCTAssertEqual(getSwitchValue(tablesQuery.switches["Helseprestasjoner"]), health)
    }
    
    func checkIfClockWasReset(element:XCUIElement) {
        XCTAssertTrue(element.childrenMatchingType(.StaticText).matchingIdentifier("0").elementBoundByIndex(0).exists)
        XCTAssertTrue(element.childrenMatchingType(.StaticText).matchingIdentifier("0").elementBoundByIndex(1).exists)
        XCTAssertTrue(element.childrenMatchingType(.StaticText).matchingIdentifier("0").elementBoundByIndex(2).exists)
    }
}