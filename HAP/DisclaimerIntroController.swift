//
//  Welcome.swift
//  HAP
//
//  Created by Fredrik Lober on 02/02/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class DisclaimerIntroController: IntroContentViewController {
    
    static let storyboardId = "disclaimer"
    @IBOutlet weak var textField: UITextView!
    
    override func viewDidAppear(_ animated: Bool) {
        textField.scrollRangeToVisible(NSMakeRange(0, 0))
    }

    @IBAction func navigateToRusTlf(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "http://www.rustelefonen.no")!)
        
    }
    @IBAction func navigateToUtesek(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "http://uteseksjonen.no")!)
    }
}
