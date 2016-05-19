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
    
    override func viewDidAppear(animated: Bool) {
        textField.scrollRangeToVisible(NSMakeRange(0, 0))
    }

    @IBAction func navigateToRusTlf(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.rustelefonen.no")!)
        
    }
    @IBAction func navigateToUtesek(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://uteseksjonen.no")!)
    }
}
