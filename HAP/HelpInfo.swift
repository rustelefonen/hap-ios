//
//  HelpInfo.swift
//  HAP
//
//  Created by Simen Fonnes on 04.02.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import Foundation
import CoreData


class HelpInfo: NSManagedObject {

    @NSManaged var htmlContent: String
    @NSManaged var title: String
    @NSManaged var category: HelpInfoCategory
    
}
