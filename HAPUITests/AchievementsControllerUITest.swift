//
//  AchievementsControllerUITest.swift
//  HAP
//
//  Created by Simen Fonnes on 04.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest

class AchievementsControllerUITest: HAPUITests {
    
    func testViewAllAchievements() {
        app.tabBars.buttons["Prestasjoner"].tap()
        app.tables.staticTexts["Du har klart en uke uten cannabis!"].tap()
    }
    
}
