//
//  Trigger.swift
//  HAP
//
//  Created by Simen Fonnes on 02.03.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import CoreData

class Trigger: NSManagedObject {
    @NSManaged var color: NSNumber
    @NSManaged var imageName: String
    @NSManaged var title: String
    @NSManaged var smokedUsers: NSSet
    @NSManaged var resistedUsers: NSSet
}
