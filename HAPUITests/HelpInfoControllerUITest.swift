//
//  HelpInfoControllerUITest.swift
//  HAP
//
//  Created by Simen Fonnes on 04.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest

class HelpInfoControllerUITest: HAPUITests {
    
    fileprivate let INFORMATION_TAB = "Informasjon"
    fileprivate let ADVICE_CATEGORY = "Råd og Tips"
    
    func testAccessHelpInfo() {
        app.tabBars.buttons[INFORMATION_TAB].tap()
        
        var tablesQuery = app.tables
        
        var index = getRand(tablesQuery.cells.count - 2)
        if index == 5 {index = 4}   //Avoid brain
        tablesQuery.cells.element(boundBy: index - 1).tap()   //Due to call and question cells.
        
        tablesQuery = app.tables
        index = getRand(tablesQuery.cells.count)
        tablesQuery.cells.element(boundBy: index - 1).tap()
        
        //Needs to assert content of webview
        XCTFail()
    }
    
    func testSearchInfo() {
        app.tabBars.buttons[INFORMATION_TAB].tap()
        app.tables.searchFields["Informasjonssider"].tap()
        app.searchFields["Informasjonssider"].typeText("otivasjo")
        app.tables["Søkeresultater"].staticTexts["Motivasjon"].tap()
        sleep(1)    //Long animation
        XCTAssertTrue(app.staticTexts["Motivasjon"].exists)
    }
    
    func testBrain() {
        app.tabBars.buttons[INFORMATION_TAB].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Hjernen"].tap()
        tablesQuery.staticTexts["3D-Hjernen"].tap()
        
        //Press brain part and check for static text
        XCTFail()
        
    }
    
    func testInternalLink() {
        app.tabBars.buttons[INFORMATION_TAB].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts[ADVICE_CATEGORY].tap()
        tablesQuery.staticTexts["Strategier"].tap()
        app.staticTexts["Trykk her for å sjekke ut tips til andre aktiviteter"].tap()
        XCTAssertTrue(app.staticTexts["Tips til andre aktiviteter"].exists)
    }
    
    func testExternalLink() {
        app.tabBars.buttons[INFORMATION_TAB].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts[ADVICE_CATEGORY].tap()
        tablesQuery.staticTexts["Tips til andre aktiviteter"].tap()
        app.staticTexts["Mer her.."].tap()
        
        //This test is useless? :P
        XCTFail()
    }
    
}
