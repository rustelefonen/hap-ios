//
//  KekCell.swift
//  HAP
//
//  Created by Simen Fonnes on 09.04.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class FormCell: UITableViewCell {
    var cellIdentifier:String!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var staticTextLabel: UILabel!
    
    @IBOutlet weak var textContent: UILabel!
}
