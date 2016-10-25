//
//  HelpInfoCategory.swift
//  HAP
//
//  Created by Fredrik Loberg on 10/02/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import Foundation
import CoreData


class HelpInfoCategory: NSManagedObject {
    struct Summary{
        let id:Int
        let versionNumber:Int
    }

    @NSManaged var title: String
    @NSManaged var order: NSNumber
    @NSManaged var helpInfo: NSSet
    @NSManaged var categoryId: NSNumber
    @NSManaged var versionNumber: NSNumber
    
    func helpInfoSorted() -> [HelpInfo]{
        let helpInfoList = helpInfo.allObjects as! [HelpInfo]
        return helpInfoList.sorted(by: {$0.title < $1.title})
    }
}
