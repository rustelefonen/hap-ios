//
//  HelpInfoCategoryTest.swift
//  HAP
//
//  Created by Simen Fonnes on 05.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest
@testable import HAP

class HelpInfoCategoryTest: XCTestCase {
    
    var helpInfoDao:HelpInfoDao!
    
    override func setUp() {
        super.setUp()
        helpInfoDao = HelpInfoDao()
    }
    
    func testHelpInfoSorted() {
        let sec1 = helpInfoDao.createNewHelpInfoCategory(1, title: "Råd og Tips")
        
        let i1 = helpInfoDao.createNewHelpInfo("Praktiske råd når du skal slutte", htmlContent: "praktiskerad")
        let i2 = helpInfoDao.createNewHelpInfo("Tips til andre aktiviteter", htmlContent: "tipstilandreaktiviteter")
        let i3 = helpInfoDao.createNewHelpInfo("Motivasjon", htmlContent: "motivasjon")
        let i5 = helpInfoDao.createNewHelpInfo("Hjelpetilbud og behandligstilbud", htmlContent: "hjelpetilbudogbehandlingstilbud")
        let i7 = helpInfoDao.createNewHelpInfo("Strategier", htmlContent: "strategier")
        let i8 = helpInfoDao.createNewHelpInfo("Risikosituasjoner og triggere", htmlContent: "risikosituasjonerogtriggere")
        sec1.helpInfo = [i1, i2, i3, i5, i7, i8]
        
        let helpInfosSorted = sec1.helpInfoSorted()
        
        var tmp = helpInfosSorted.first
        for helpInfo in helpInfosSorted {
            XCTAssertTrue(tmp!.title <= helpInfo.title)
            tmp = helpInfo
        }
    }
}