//
//  UserTriggerTest.swift
//  HAP
//
//  Created by Simen Fonnes on 05.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest
import CoreData
@testable import HAP

class UserTriggerTest: XCTestCase {
    
    var userInfoDao:UserInfoDao!
    var userInfo:UserInfo!
    
    override func setUp() {
        super.setUp()
        userInfoDao = UserInfoDao()
        userInfo = userInfoDao.createNewUserInfo()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSetUser() {
        
        
    }
    
    /*
    enum Kind: String{
        case Smoked, Resisted
    }
    
    @NSManaged var kind: String
    @NSManaged var count: NSNumber
    @NSManaged var smokedTrigger: Trigger?
    @NSManaged var resistedTrigger: Trigger?
    @NSManaged var smokedUser: UserInfo?
    @NSManaged var resistedUser: UserInfo?
    
    
    func setUser(user:UserInfo?){
        let kind = Kind(rawValue: self.kind)
        
        switch kind {
        case .Smoked?:
            smokedUser = user
            resistedUser = nil
        default:
            resistedUser = user
            smokedUser = nil
        }
    }
    
    func setTrigger(trigger:Trigger?){
        let kind = Kind(rawValue: self.kind)
        
        switch kind {
        case .Smoked?:
            smokedTrigger = trigger
            resistedTrigger = nil
        default:
            resistedTrigger = trigger
            smokedTrigger = nil
        }
    }
    
    func setKind(kind:Kind){
        self.kind = kind.rawValue
        
        //flipping relationships
        setTrigger(resistedTrigger ?? smokedTrigger)
        setUser(resistedUser ?? smokedUser)
    }
    
    func getTrigger() -> Trigger?{
        let kind = Kind(rawValue: self.kind)
        return kind == .Smoked ? smokedTrigger : resistedTrigger
    }
    
    func getUser() -> UserInfo?{
        let kind = Kind(rawValue: self.kind)
        return kind == .Smoked ? smokedUser : resistedUser
    }
    
    func incrementCount(){
        count = NSNumber(int: count.intValue + 1)
    }*/
    
}
