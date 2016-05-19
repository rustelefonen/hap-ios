//
//  NumberUtilTest.swift
//  HAP
//
//  Created by Simen Fonnes on 12.04.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest
@testable import HAP

class NumberUtilTest: XCTestCase {
    
    func testCGFloat() {
        let firstCGFloat:CGFloat = 2.54312
        let secondCGFloat:CGFloat = 2.54567
        
        XCTAssertTrue(firstCGFloat.isEqualTo(secondCGFloat, decimalsToCompare: 2))
        
        let thirdCGFloat:CGFloat = 2.54312
        let fourthCGFloat:CGFloat = 2.55312
        
        XCTAssertFalse(thirdCGFloat.isEqualTo(fourthCGFloat, decimalsToCompare: 2))
        
        let fifthCGFloat:CGFloat = 5.75847694749574939
        let sixthCGFloat:CGFloat = 5.75847694749574939
        
        XCTAssertTrue(fifthCGFloat.isEqualTo(sixthCGFloat, decimalsToCompare: 17))
    }
}
