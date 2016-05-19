//
//  ProgramControllerUITest.swift
//  HAP
//
//  Created by Simen Fonnes on 04.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest

class ProgramControllerUITest: HAPUITests {
    
    func testAddPositiveTrigger() {
        app.tabBars.buttons["Oversikt"].tap()
        
        var element = app.scrollViews.otherElements.containingType(.StaticText, identifier:"Triggere som fører til bruk").childrenMatchingType(.Other).elementBoundByIndex(0)
        
        //XCTAssertTrue(element..boolValue)
        
        app.navigationBars["Oversikt"].buttons["Ny melding"].tap()
        app.images["Resisted"].tap()
        app.collectionViews.images["Drinking"].tap()
        app.navigationBars["Triggerdagbok"].buttons["Lagre"].tap()
        
        element = app.scrollViews.otherElements.containingType(.StaticText, identifier:"Triggere som fører til bruk").childrenMatchingType(.Other).elementBoundByIndex(0)
        
        XCTAssertFalse(element.accessibilityElementsHidden.boolValue)
        
        
        
        removePosTriggers()     //Cleanup
        
        //XCTFail()
    }
    
    func testAddNegativeTrigger() {
        app.tabBars.buttons["Oversikt"].tap()
        app.navigationBars["Oversikt"].buttons["Ny melding"].tap()
        app.images["HaveSmoked"].tap()
        app.collectionViews.images["Party"].tap()
        app.navigationBars["Triggerdagbok"].buttons["Lagre"].tap()
        
        removeNegTriggers()     //Cleanup
        
        //XCTFail()
    }
    
    func testOverlayWithArrowAppears() {
        app.tabBars.buttons["Oversikt"].tap()
        app.scrollViews.otherElements.containingType(.StaticText, identifier:"Aktiviteter som hjelper mot suget").staticTexts["for å legge til data"].tap()
        
        let overlayElement = app.otherElements.containingType(.Image, identifier:"TriggerdagbokTutorial").element
        XCTAssertTrue(overlayElement.exists)
        overlayElement.tap()
        XCTAssertFalse(overlayElement.exists)
    }
    
    func testPositiveTriggerDialog() {
        let content = "Dersom du motstår å ruse deg kan du registrere det i triggerdagboken.\n\n Over tid vil dette vinduet gi deg en god oversikt over hva som hjelper best, når suget melder seg."
        app.tabBars.buttons["Oversikt"].tap()
        app.scrollViews.otherElements.containingType(.StaticText, identifier:"Aktiviteter som hjelper mot suget").buttons["Mer info"].tap()
        
        XCTAssertTrue(app.staticTexts["Aktiviteter mot suget"].exists)
        XCTAssertTrue(app.staticTexts[content].exists)
        
        app.alerts["Aktiviteter mot suget"].collectionViews.buttons["OK"].tap()
        
        XCTAssertFalse(app.staticTexts["Aktiviteter mot suget"].exists)
        XCTAssertFalse(app.staticTexts[content].exists)
    }
    
    func testNegativeTriggerDialog() {
        let content = "Dersom du ruser deg kan du registrere det i triggerdagboken.\n\n Over tid vil dette vinduet gi deg en god oversikt over hvilke situasjoner du bør passe deg for."
        app.tabBars.buttons["Oversikt"].tap()
        app.scrollViews.otherElements.containingType(.StaticText, identifier:"Triggere som fører til bruk").buttons["Mer info"].tap()
        
        XCTAssertTrue(app.staticTexts["Farlige triggere"].exists)
        XCTAssertTrue(app.staticTexts[content].exists)
        
        app.alerts["Farlige triggere"].collectionViews.buttons["OK"].tap()
        
        XCTAssertFalse(app.staticTexts["Farlige triggere"].exists)
        XCTAssertFalse(app.staticTexts[content].exists)
        
    }
    
    func removePosTriggers() {
        app.navigationBars["Oversikt"].buttons["settings"].tap()
        app.sheets.collectionViews.buttons["Tilbakestilling"].tap()
        app.tables.staticTexts["Tilbakestill positive triggere"].tap()
        app.alerts["Tilbakestill positive triggere"].collectionViews.buttons["Tilbakestill"].tap()
    }
    
    func removeNegTriggers() {
        app.navigationBars["Oversikt"].buttons["settings"].tap()
        app.sheets.collectionViews.buttons["Tilbakestilling"].tap()
        app.tables.staticTexts["Tilbakestill negative triggere"].tap()
        app.alerts["Tilbakestill negative triggere"].collectionViews.buttons["Tilbakestill"].tap()
    }
}
