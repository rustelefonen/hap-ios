//
//  UserTrigger.swift
//  HAP
//
//  Created by Simen Fonnes on 09.03.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import Foundation
import CoreData


class UserTrigger: NSManagedObject {
    enum Kind: String{
        case Smoked, Resisted
    }

    @NSManaged var kind: String
    @NSManaged var count: NSNumber
    @NSManaged var smokedTrigger: Trigger?
    @NSManaged var resistedTrigger: Trigger?
    @NSManaged var smokedUser: UserInfo?
    @NSManaged var resistedUser: UserInfo?
    
    
    func setUser(_ user:UserInfo?){
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
    
    func setTrigger(_ trigger:Trigger?){
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
    
    func setKind(_ kind:Kind){
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
        count = NSNumber(value: count.int32Value + 1 as Int32)
    }
    
}
