//
//  ColorUtilTest.swift
//  HAP
//
//  Created by Simen Fonnes on 12.04.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest
@testable import HAP

class ColorUtilTest: XCTestCase {
    
    func testUIColor() {
        let colorFromCustomConstructor = UIColor(rgba: 0xEFEFEFFF)
        let colorFromNormalConstructor = UIColor(red: 0xEF/255, green: 0xEF/255, blue: 0xEF/255, alpha: 0xFF/255)
        
        XCTAssertEqual(colorFromCustomConstructor, colorFromNormalConstructor)
    }
    
    func testMakeUIColorLighter() {
        let color = UIColor(rgba: 0xEFEFEFFF)
        XCTAssertFalse(color.makeUIColorLighter(0.5).isEqual(UIColor(rgba: 0xEFEFEFFF)))
    }
}